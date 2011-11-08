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
        @connection = GData::Connection.new(settings[:domain], settings[:token])

        users = GData::Provision::User.all(@connection)

        puts "%-20s %-20s %-20s %-8s %-8s" % %w{username givenname familyname admin suspended}
        users.each do |user|
          puts "%-20s %-20s %-20s %-8s %-8s" % [user.user_name, user.given_name, user.family_name, user.admin, user.suspended]
        end
      end
    end
  end
end
