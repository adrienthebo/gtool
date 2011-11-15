require 'thor'
require 'gtool'
require 'gtool/auth'
require 'gdata'

class Gtool
  module Provision
    class Group < Thor
      Gtool.register self, "group", "group <COMMAND>", "GData group provisioning"
      namespace :group

      desc "list", "List users"
      def list
        settings = Gtool::Auth.load_auth
        connection = GData::Connection.new(settings[:domain], settings[:token])

        groups = GData::Provision::Group.all(connection)

        fields = [:group_id, :group_name, :email_permission, :description]

        rows = groups.map do |group|
          fields.map {|f| group.send f}
        end

        print_table rows
      end

      desc "members GROUP", "Display members of a group"
      def members(group)
        settings = Gtool::Auth.load_auth
        connection = GData::Connection.new(settings[:domain], settings[:token])

        group = GData::Provision::Group.get(connection, group)

        members = group.list_members

        fields = [:member_id, :member_type, :direct_member]
        rows = members.map do |member|
          fields.map {|f| member.send f}
        end

        print_table rows
      end

      desc "addmember GROUP MEMBER", "Add a member to a group"
      def addmember(group, member)
        settings = Gtool::Auth.load_auth
        connection = GData::Connection.new(settings[:domain], settings[:token])
        group = GData::Provision::Group.get(connection, group)

        group.add_member member
      end

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end
    end
  end
end
