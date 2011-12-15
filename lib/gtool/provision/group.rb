require 'thor'
require 'gtool'
require 'gtool/util/ask_default'
require 'gdata'

module Gtool
  module Provision
    class Group < Thor
      include Gtool::Util
      Gtool::CLI.register self, "group", "group [COMMAND]", "GData group provisioning"
      namespace :group

      class_option "debug", :type => :boolean, :default => false, :desc => "Enable debug output", :aliases => "-d"
      class_option "noop",  :type => :boolean, :default => false, :desc => "Enable noop mode", :aliases => "-n"

      desc "list", "List groups"
      def list
        connection = Gtool::Auth.connection(options)
        groups = GData::Provision::Group.all(connection)
        fields = GData::Provision::Group.attribute_names
        field_names = GData::Provision::Group.attribute_titles

        rows = groups.map do |group|
          fields.map {|f| group.send f}
        end

        rows.unshift field_names
        print_table rows
        say "#{rows.length - 1} entries.", :cyan
      end

      desc "get GROUP", "Get a particular group instance"
      def get(groupname)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.get(connection, groupname)
        fields = GData::Provision::Group.attribute_names
        field_names = GData::Provision::Group.attribute_titles

        if group.nil?
          say "Group '#{groupname}' not found!", :red
        else
          properties = fields.map {|f| group.send f}
          print_table field_names.zip(properties)
        end
      end

      desc "create GROUP", "Create a new group"
      def create(groupname)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.new(:connection => connection)

        group.group_id = groupname
        group.group_name        = ask "Group name:"
        group.email_permission  = ask "Email Permission:"
        group.permission_preset = ask "Permission Preset:"
        group.description       = ask "Group Description:"

        group.create!

        invoke "group:get", [group.group_id]
      end

      # TODO update group This is pending on the the backing group being able
      # to store the group_id for the case that the group_id here is changed,
      # but needs to post back to a specific url

      desc "members GROUP", "Display members of a group"
      def members(groupname)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.get(connection, groupname)
        fields = GData::Provision::Member.attribute_names
        field_names = GData::Provision::Member.attribute_titles

        if group.nil?
          say "Group '#{groupname}' not found!", :red
        else
          members = group.list_members

          rows = members.map do |member|
            fields.map {|f| member.send f}
          end

          rows.unshift field_names
          print_table rows
        say "#{rows.length - 1} entries.", :cyan
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

      desc "owners GROUP", "Display owners of a group"
      def owners(groupname)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.get(connection, groupname)
        fields = GData::Provision::Owner.attribute_names
        field_names = GData::Provision::Owner.attribute_titles

        if group.nil?
          say "Group '#{groupname}' not found!", :red
        else
          owners = group.list_owners

          if owners.nil?
            say "Group #{groupname} has no owners!", :red
          else
            rows = owners.map { |owner| fields.map {|f| owner.send f} }

            rows.unshift field_names
            # XXX https://github.com/wycats/thor/issues/100
            # print_table rows
            puts rows.join("\n")
            say "#{rows.length - 1} entries.", :cyan
          end
        end
      end

      desc "addowner GROUP OWNER", "Add an owner to a group"
      def addowner(groupname, owner)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.get(connection, groupname)

        if group.nil?
          say "Group '#{groupname}' not found!", :red
        else
          group.add_owner owner
          invoke "group:owners", [groupname]
        end
      end

      desc "delowner GROUP OWNER", "Remove an owner from a group"
      def delowner(groupname, owner)
        connection = Gtool::Auth.connection(options)
        group = GData::Provision::Group.get(connection, groupname)

        if group.nil?
          say "Group '#{groupname}' not found!", :red
        else
          group.del_owner owner
          invoke "group:owners", [groupname]
        end
      end

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end
    end
  end
end
