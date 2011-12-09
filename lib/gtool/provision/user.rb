require 'thor'
require 'gtool'
require 'gtool/util/ask_default'
require 'gdata'
require 'digest/sha1'

module Gtool
  module Provision
    class User < Thor
      include Gtool::Util
      Gtool::CLI.register self, "user", "user [COMMAND]", "GData user provisioning"
      namespace :user

      class_option "debug", :type => :boolean, :desc => "Enable debug output", :aliases => "-d"
      class_option "noop",  :type => :boolean, :desc => "Enable noop mode", :aliases => "-n"

      desc "list", "List users"
      def list
        connection = Gtool::Auth.connection(options)
        users = GData::Provision::User.all(connection)
        fields = GData::Provision::User.attribute_names
        field_names = GData::Provision::User.attribute_titles

        rows = users.map do |user|
          fields.map {|f| user.send f}
        end

        rows.unshift field_names
        print_table rows
        say "#{rows.length - 1} entries.", :cyan
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

        user = GData::Provision::User.new(:connection => connection)

        user.user_name = username
        user.given_name = ask "Given Name:"
        user.family_name = ask "Family Name:"

        # password! wheee!
        %x{stty -echo}
        user.password = Digest::SHA1.hexdigest(ask "Password:")
        user.hash_function_name = "SHA-1"
        %x{stty echo}

        user.create!

        invoke "user:get", [user.user_name]
      end

      desc "update USER", "Update an existing user"
      def update(username)
        connection = Gtool::Auth.connection(options)

        user = GData::Provision::User.get(connection, username)

        user.user_name = ask_default(user.user_name, "Username (#{user.user_name}):")
        user.given_name = ask_default(user.given_name, "Given Name (#{user.given_name}):")
        user.family_name = ask_default(user.family_name, "Family Name (#{user.family_name}):")
        user.admin = ask_default(user.admin, "Administrator (#{user.admin}):")
        user.agreed_to_terms = ask_default(user.agreed_to_terms, "Agreed to terms (#{user.agreed_to_terms}):")
        user.change_password_at_next_login = ask_default(user.change_password_at_next_login, "Change password at next login (#{user.change_password_at_next_login}):")
        user.suspended = ask_default(user.suspended, "Suspended (#{user.suspended}):")

        # password! wheee!
        %x{stty -echo}
        password = ask "Password (blank will not change):"
        unless password.empty?
          user.password = Digest::SHA1.hexdigest(password)
          user.hash_function_name = "SHA-1"
        end
        %x{stty echo}

        user.update!

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

      desc "groups USER", "Retrieve groups for a user"
      def groups(username)
        connection = Gtool::Auth.connection(options)
        groups = GData::Provision::Group.all(connection, :member => username)
        fields = GData::Provision::Group.attribute_names
        field_names = GData::Provision::Group.attribute_titles

        rows = groups.map do |group|
          fields.map {|f| group.send f}
        end

        rows.unshift field_names
        print_table rows
        say "#{rows.length - 1} entries.", :cyan
      end

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end
    end
  end
end
