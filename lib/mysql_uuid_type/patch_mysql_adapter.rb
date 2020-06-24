require 'active_record'
require 'active_support/concern'
require "active_record/connection_adapters/mysql2_adapter"

module MysqlUUIDType
  module Patches

    module ActiveRecordColumnsSupport
      extend ActiveSupport::Concern

      included do
        def type_cast_with_uuid(value)
          return nil if type == :uuid and !value.nil? && value == ["00000000000000000000000000000000"].pack("H*")
          return UUIDTools::UUID.serialize(value) if type == :uuid
          type_cast_without_uuid(value)
        end

        def type_cast_code_with_uuid(var_name)
          return "UUIDTools::UUID.serialize(#{var_name})" if type == :uuid
          type_cast_code_without_uuid(var_name)
        end

        def simplified_type_with_uuid(field_type)
          return :uuid if field_type == 'binary(16)' || field_type == 'binary(16,0)'
          simplified_type_without_uuid(field_type)
        end

        alias_method_chain :type_cast, :uuid
        alias_method_chain :type_cast_code, :uuid if ActiveRecord::VERSION::MAJOR < 4
        alias_method_chain :simplified_type, :uuid
      end
    end

    module AdapterConversion
      extend ActiveSupport::Concern

      included do
        def quote_with_visiting(value, column = nil)
          value = UUIDTools::UUID.serialize(value) if column && column.type == :uuid
          quote_without_visiting(value, column)
        end

        def type_cast_with_visiting(value, column = nil)
          value = UUIDTools::UUID.serialize(value) if column && column.type == :uuid
          type_cast_without_visiting(value, column)
        end

        def native_database_types_with_uuid
          @native_database_types ||= native_database_types_without_uuid.merge(uuid: { name: 'binary', limit: 16 })
        end

        alias_method_chain :quote, :visiting
        alias_method_chain :type_cast, :visiting
        alias_method_chain :native_database_types, :uuid
      end
    end

    module AdapterWithTypes
      extend ActiveSupport::Concern

      included do
        def initialize_type_map_with_uuid(m)
          initialize_type_map_without_uuid(m)
          register_class_with_limit m, /binary\(16(,0)?\)/i, ::ActiveRecord::Type::UUID
        end

        alias_method_chain :initialize_type_map, :uuid
      end
    end

    module Adapters
      extend ActiveSupport::Concern

      included do
        alias_method :original_type_to_sql, :type_to_sql
        def type_to_sql(type, limit = nil, precision = nil, scale = nil)
          case type.to_s
          when 'uuid'
            'binary(16)'
          else
            original_type_to_sql(type, limit, precision, scale)
          end
        end
      end
    end
  end
end