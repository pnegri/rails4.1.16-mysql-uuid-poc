require 'mysql_uuid_type/short_uuid'
require 'mysql_uuid_type/active_record_type'
require 'mysql_uuid_type/patch_mysql_adapter'
require 'mysql_uuid_type/patch_uuid'
require 'mysql_uuid_type/patch_migrations'
require 'mysql_uuid_type/patch_schema_dumper'
require 'mysql_uuid_type/extend_string'
require 'mysql_uuid_type/extend_arel'
require 'mysql_uuid_type/railtie' if defined?(Rails::Railtie)
require 'mysql_uuid_type/patches'

module MysqlUUIDType
end

MysqlUUIDType::Patches.apply!
