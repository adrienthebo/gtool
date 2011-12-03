require 'thor'
require 'gtool'
require 'gdata'

module Gtool
  module Provision
    class Group < Thor
      Gtool::CLI.register self, "group", "group [COMMAND]", "GData group provisioning"
      namespace :group

      class_option "debug", :type => :boolean, :default => false, :desc => "Enable debug output", :aliases => "-d"
      class_option "noop",  :type => :boolean, :default => false, :desc => "Enable noop mode", :aliases => "-n"

      desc "list", "List groups"
      def list
        connection = Gtool::Auth.connection(options)
        groups = GData::Provision::Group.all(connection)

        fields = [:group_id, :group_name, :email_permission, :description]

        rows = groups.map do |group|
          fields.map {|f| group.send f}
        end

        print_table rows
        say "#{rows.length} entries.", :cyan
      end

      desc "get GROUP", "Get a particular group instance"
      def get(groupname)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.get(connection, groupname)

        if group.nil?
          say "Group '#{groupname}' not found!", :red
        else

          group.attributes.each do |attr|
            print "#{attr.first}: "
            puts group.send attr.first
          end
        end
      end

      desc "members GROUP", "Display members of a group"
      def members(groupname)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.get(connection, groupname)

        if group.nil?
          say "Group '#{groupname}' not found!", :red
        else
          members = group.list_members

          fields = [:member_id, :member_type, :direct_member]
          rows = members.map do |member|
            fields.map {|f| member.send f}
          end

          print_table rows
          say "#{rows.length} entries.", :cyan
        end
      end

      desc "addmember GROUP MEMBER", "Add a member to a group"
      def addmember(groupname, member)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.get(connection, groupname)

        if group.nil?
          say "Group '#{groupname}' not found!", :red
        else
          group.add_member member
          invoke "group:members", [groupname]
        end
      end

      desc "delmember GROUP MEMBER", "Remove a member from a group"
      def delmember(groupname, member)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.get(connection, groupname)

        if group.nil?
          say "Group '#{groupname}' not found!", :red
        else
          group.del_member member
          invoke "group:members", [groupname]
        end
      end

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end
    end
  end
end
