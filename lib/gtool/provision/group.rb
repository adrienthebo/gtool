require 'thor'
require 'gtool'
require 'gtool/auth'
require 'gdata'

class Gtool
  module Provision
    class Group < Thor
      Gtool.register self, "group", "group", "GData user provisioning"

      desc "list", "List users"
      def list
        settings = Gtool::Auth.load_auth
        connection = GData::Connection.new(settings[:domain], settings[:token])

        groups = GData::Provision::Group.all(connection)

        fields = [
          {:group_id         => "%-40s"},
          {:group_name       => "%-30s"},
          {:email_permission => "%-7s"},
          {:description      => "%s"},
        ]

        format_str = fields.map {|field| field.values }.flatten.join(" ")
        puts format_str % fields.map {|field| field.keys}.flatten
        groups.each do |group|
          puts format_str % fields.map {|field| field.keys}.flatten.map {|field| group.send field}
        end
      end
    end
  end
end

