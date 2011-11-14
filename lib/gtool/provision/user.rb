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

        fields = [:user_name, :given_name, :family_name, :admin, :suspended]

        rows = users.map do |user|
          fields.map {|f| user.send f}
        end

        print_table rows
      end
    end
  end
end
