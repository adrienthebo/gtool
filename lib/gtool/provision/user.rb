require 'thor'
require 'gtool'
require 'gtool/auth'
require 'gdata'

class Gtool
  module Provision
    class User < Thor
      Gtool.register self, "user", "user", "GData user provisioning"

      desc "list", "List users"
      def list
        settings = Gtool::Auth.load_auth
        connection = GData::Connection.new(settings[:domain], settings[:token])

        users = GData::Provision::User.all(connection)

        fields = [
          {:user_name   => "%-20s"},
          {:given_name  => "%-20s"},
          {:family_name => "%-15s"},
          {:admin       => "%-6s"},
          {:suspended   => "%-6s"},
        ]

        format_str = fields.map {|field| field.values }.flatten.join(" ")
        puts format_str % fields.map {|field| field.keys}.flatten
        users.each do |user|
          puts format_str % fields.map {|field| field.keys}.flatten.map {|field| user.send field}
        end
      end
    end
  end
end
