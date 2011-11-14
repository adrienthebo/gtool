require 'thor'
require 'gtool'
require 'gtool/auth'
require 'gdata'

class Gtool
  module Provision
    class Group < Thor
      Gtool.register self, "group", "group", "GData user provisioning"

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
    end
  end
end
