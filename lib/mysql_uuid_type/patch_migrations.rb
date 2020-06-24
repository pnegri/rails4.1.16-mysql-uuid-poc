require 'active_record'
require 'active_support/concern'

module MysqlUUIDType
  module Patches
    module Migrations
      def uuid(*column_names)
        options = column_names.extract_options!
        column_names.each do |name|
          column(name, "binary(16)#{' PRIMARY KEY' if options.delete(:primary_key)}", options)
        end
      end
    end
  end
end