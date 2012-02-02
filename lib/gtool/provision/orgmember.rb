require 'thor'
require 'gtool'
require 'gprov'

module Gtool
  module Provision
    class OrgMember < Thor
      Gtool::CLI.register self, "orgmember", "orgmember [COMMAND]", "GProv organizational member provisioning"
      namespace :orgmember

      class_option "debug", :type => :boolean, :desc => "Enable debug output", :aliases => "-d"
      class_option "noop",  :type => :boolean, :desc => "Enable noop mode", :aliases => "-n"

      desc "list", "Get the members of an orgunit"
      method_option "orgunit", :type => :string, :desc => "The orgunit from which to retrive users"
      def list
        if options[:orgunit]
          options_hash = {:target => :orgunit, :orgunit => options[:orgunit]}
        else
          options_hash = {:target => :all}
        end

        connection = Gtool::Auth.connection(options)
        orgmembers = GProv::Provision::OrgMember.all(connection, options_hash)
        fields = GProv::Provision::OrgMember.attribute_names
        field_names = GProv::Provision::OrgMember.attribute_titles

        rows = orgmembers.map do |member|
          fields.map {|f| member.send f}
        end

        rows.unshift field_names
        print_table rows
        say "#{rows.length - 1} entries.", :cyan
      end

      desc "get MEMBER", "Retrieve a specific orgunit member"
      def get(membername)
        connection = Gtool::Auth.connection(options)
        orgmember = GProv::Provision::OrgMember.get(connection, membername)
        fields = GProv::Provision::OrgMember.attribute_names
        field_names = GProv::Provision::OrgUnit.attribute_titles

        if orgmember.nil?
          say "Organizational unit '#{orgmember}' not found!", :red
        else
          properties = fields.map {|f| orgmember.send f}
          print_table field_names.zip(properties)
        end
      end

      desc "move ORG_MEMBER, NEW_ORGUNIT", "Move an organization unit member"
      def move(membername, orgunit)
        connection = Gtool::Auth.connection(options)
        orgmember = GProv::Provision::OrgMember.get(connection, membername)
        orgmember.org_unit_path = orgunit
        orgmember.update!

        invoke "orgmember:get", [membername]
      end

      def self.banner(task, namespace = true, subcommand = false)
        "#{basename} #{task.formatted_usage(self, true, subcommand)}"
      end
    end
  end
end
