require 'mysql_uuid_type'
require 'rails'

module MysqlUUIDType
  class Railtie < Rails::Railtie
    railtie_name :mysql_uuid_type

    config.to_prepare do
      # MysqlUUIDType::Patches.apply!
    end
  end
end