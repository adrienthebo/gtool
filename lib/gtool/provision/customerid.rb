require 'thor'
require 'thor/group'
require 'gtool'
require 'gprov'

module Gtool
  module Provision
    class CustomerID < Thor::Group
      Gtool::CLI.register self, "customerid", "customerid", "Display Customer ID for the domain"

      class_option "debug", :type => :boolean, :default => false, :desc => "Enable debug output", :aliases => "-d"
      class_option "noop",  :type => :boolean, :default => false, :desc => "Enable noop mode", :aliases => "-n"

      def display
        connection = Gtool::Auth.connection(options)
        fields = GProv::Provision::CustomerID.attribute_names
        field_names = GProv::Provision::CustomerID.attribute_titles
        id = GProv::Provision::CustomerID.get(connection)

        properties = fields.map {|f| id.send f}
        print_table field_names.zip(properties)
      end
    end
  end
end
