require 'active_record'
require 'active_support/concern'

module MysqlUUIDType
  module Patches
    def self.apply!
      #ActiveRecord::ConnectionAdapters::Table.send :include, Migrations if defined? ActiveRecord::ConnectionAdapters::Table
      ActiveRecord::ConnectionAdapters::TableDefinition.send :include, Migrations if defined? ActiveRecord::ConnectionAdapters::TableDefinition

      #ActiveRecord::ConnectionAdapters::Mysql2Adapter.send :include, Adapters if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter
      if ActiveRecord::VERSION::MAJOR >= 4 and ActiveRecord::VERSION::MINOR >= 2
        #ActiveRecord::ConnectionAdapters::Mysql2Adapter.send :include, AdapterWithTypes if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter
      else
        ActiveRecord::ConnectionAdapters::Column.send :include, ActiveRecordColumnsSupport
      end

      ActiveRecord::ConnectionAdapters::Mysql2Adapter.send :include, AdapterConversion if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter

      #ActiveRecord::SchemaDumper.send :include, ActiveRecordSchemaDumperSupport if defined? ActiveRecord::SchemaDumper
      ActiveRecord::Base.send :include, MysqlUUIDType::UUID if defined? ActiveRecord::Base
    end
  end
end