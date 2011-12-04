require 'thor'
require 'gtool'
require 'gdata'
require 'digest/sha1'

module Gtool
  module Provision
    class User < Thor
      Gtool::CLI.register self, "user", "user [COMMAND]", "GData user provisioning"
      namespace :user

      class_option "debug", :type => :boolean, :desc => "Enable debug output", :aliases => "-d"
      class_option "noop",  :type => :boolean, :desc => "Enable noop mode", :aliases => "-n"

      desc "list", "List users"
      def list
        connection = Gtool::Auth.connection(options)
        users = GData::Provision::User.all(connection)
        fields = GData::Provision::User.attributes

        rows = users.map do |user|
          fields.map {|f| user.send f}
        end

        # TODO columns need headers
        print_table rows
        say "#{rows.length} entries.", :cyan
      end

      desc "get USER", "Get a user"
      def get(username)
        connection = Gtool::Auth.connection(options)
        user = GData::Provision::User.get(connection, username)
        fields = GData::Provision::User.attributes
        field_names = GData::Provision::User.attribute_names

        if user.nil?
          say "User '#{username}' not found!", :red
        else
          properties = fields.map {|f| user.send f}
          print_table field_names.zip(properties)
        end
      end

      desc "create USER", "Create a new user"
      def create(username)
        connection = Gtool::Auth.connection(options)

        user = GData::Provision::User.new
        user.connection = connection

        user.user_name = username
        user.given_name = ask "Given Name:"
        user.family_name = ask "Family Name:"

        # password! wheee!
        %x{stty -echo}
        user.password = Digest::SHA1.hexdigest(ask "Password: ")
        user.hash_function_name = "SHA-1"
        %x{stty echo}

        user.create!

        invoke "user:get", [user.user_name]
      end

      desc "delete USER", "Delete a user"
      def delete(username)
        connection = Gtool::Auth.connection(options)
        invoke "user:get", [username]
        user = GData::Provision::User.get(connection, username)

        if user and (yes? "Permanently delete this user?") and (username == ask("Type in #{username} to confirm:"))
          user.delete!
        end
      end

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end
    end
  end
end
