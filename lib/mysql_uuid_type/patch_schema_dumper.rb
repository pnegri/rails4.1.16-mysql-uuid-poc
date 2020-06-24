module MysqlUUIDType
  module Patches

    module ActiveRecordSchemaDumperSupport
      extend ActiveSupport::Concern

      included do
        def table_with_mysql_uuid(table, stream)
          create_table_stream = StringIO.new
          table_without_mysql_uuid(table, create_table_stream)

          columns = @connection.columns(table)
          begin

            additional_table_stream = StringIO.new

            if @connection.respond_to?(:pk_and_sequence_for)
              pk, _ = @connection.pk_and_sequence_for(table)
            end
            if !pk && @connection.respond_to?(:primary_key)
              pk = @connection.primary_key(table)
            end

            column_specs = columns.map do |column|
              raise StandardError, "Unknown type '#{column.sql_type}' for column '#{column.name}'" unless @connection.valid_type?(column.type)
              next unless column.name == pk && column.sql_type == 'binary(16)'
              @connection.column_spec(column, @types)
            end.compact

            all_column_specs = columns.map do |column|
              raise StandardError, "Unknown type '#{column.sql_type}' for column '#{column.name}'" unless @connection.valid_type?(column.type)
              @connection.column_spec(column, @types)
            end.compact

            keys = @connection.migration_keys

            # figure out the lengths for each column based on above keys
            lengths = keys.map { |key|
              all_column_specs.map { |spec|
                spec[key] ? spec[key].length + 2 : 0
              }.max
            }

            # the string we're going to sprintf our values against, with standardized column widths
            format_string = lengths.map{ |len| "%-#{len}s" }

            # find the max length for the 'type' column, which is special
            type_length = all_column_specs.map{ |column| column[:type].length }.max

            # add column type definition to our format string
            format_string.unshift "    t.%-#{type_length}s "

            format_string *= ''

            create_table_stream.rewind
            additional_table_stream.print create_table_stream.gets

            column_specs.each do |colspec|
              values = keys.zip(lengths).map{ |key, len| colspec.key?(key) ? colspec[key] + ", " : " " * len }
              values.unshift colspec[:type]
              additional_table_stream.print((format_string % values).gsub(/,\s*$/, ''))
              additional_table_stream.puts
            end

            additional_table_stream.print create_table_stream.read

            additional_table_stream.rewind
            stream.print additional_table_stream.read
          rescue => e
            stream.puts "# Could not dump table #{table.inspect} because of following #{e.class}"
            stream.puts "#   #{e.message}"
            stream.puts
          end
          stream
        end
        alias_method_chain :table, :mysql_uuid

      end
    end

  end
end