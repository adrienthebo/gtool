require 'gtool'
require 'yaml'

class Gtool
  module Auth
    def self.load_auth
      settings = nil
      File.open "#{ENV['HOME']}/.gtool.yaml" do |f|
        settings = YAML::load f.read
      end
      settings
    end
  end
end
