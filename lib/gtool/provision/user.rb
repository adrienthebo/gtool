require 'thor'
require 'gtool'
require 'gdata'

class Gtool
  module Provision
    class User < Thor
      Gtool.register self, "user", "user [COMMAND]", "GData user provisioning"
      namespace :user

      class_option "debug", :desc => "Enable debug output", :aliases => "-d"
      class_option "noop",  :desc => "Enable noop mode", :aliases => "-n"

      desc "list", "List users"
      def list
        connection = Gtool::Auth.connection(options)
        users = GData::Provision::User.all(connection)

        fields = [:user_name, :given_name, :family_name, :admin, :suspended, :change_password_at_next_login]

        rows = users.map do |user|
          fields.map {|f| user.send f}
        end

        print_table rows
        say "#{rows.length} entries.", :cyan
      end

      desc "get USER", "Get a user"
      def get(username)
        connection = Gtool::Auth.connection(options)
        user = GData::Provision::User.get(connection, username)

        if user.nil?
          say "User '#{username}' not found!", :red
        else
          fields = [:user_name, :given_name, :family_name, :admin, :suspended]

          properties = fields.map {|f| user.send f}
          fields.map! {|f| f.to_s.capitalize.sub(/$/, ":") }

          print_table fields.zip(properties)
        end
      end

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end
    end
  end
end
