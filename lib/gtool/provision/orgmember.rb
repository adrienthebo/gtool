require 'thor'
require 'gtool'
require 'gdata'

module Gtool
  module Provision
    class OrgMember < Thor
      Gtool::CLI.register self, "orgmember", "orgmember [COMMAND]", "GData organizational member provisioning"
      namespace :orgmember

      class_option "debug", :type => :boolean, :desc => "Enable debug output", :aliases => "-d"
      class_option "noop",  :type => :boolean, :desc => "Enable noop mode", :aliases => "-n"

      desc "members ORGUNIT", "Get the members of an orgunit"
      def members(orgunit_name)
        connection = Gtool::Auth.connection(options)
        orgmembers = GData::Provision::OrgMember.all(connection, :target => :orgunit, :orgunit => orgunit_name)
        fields = GData::Provision::OrgMember.attribute_names
        field_names = GData::Provision::OrgMember.attribute_titles

        rows = orgmembers.map do |member|
          fields.map {|f| member.send f}
        end

        rows.unshift field_names
        print_table rows
        say "#{rows.length - 1} entries.", :cyan
      end

      desc "allmembers", "Retrieve all organization users"
      def allmembers
        connection = Gtool::Auth.connection(options)
        fields = GData::Provision::OrgMember.attribute_names
        field_names = GData::Provision::OrgMember.attribute_titles

        members = GData::Provision::OrgMember.all(connection, :target => :all)

        rows = members.map do |member|
          fields.map {|f| member.send f}
        end

        rows.unshift field_names
        print_table rows
        say "#{rows.length - 1} entries.", :cyan
      end

      desc "get MEMBER", "Retrieve a specific orgunit member"
      def get(membername)
        connection = Gtool::Auth.connection(options)
        orgmember = GData::Provision::OrgMember.get(connection, membername)
        fields = GData::Provision::OrgMember.attribute_names
        field_names = GData::Provision::OrgUnit.attribute_titles

        if orgmember.nil?
          say "Organizational unit '#{orgmember}' not found!", :red
        else
          properties = fields.map {|f| orgmember.send f}
          print_table field_names.zip(properties)
        end
      end

      desc "move ORG_MEMBER, NEW_ORGUNIT", "Move an organization unit member"
      def move(membername, orgunit)
      end

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end
    end
  end
end
