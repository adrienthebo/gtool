require 'gtool'
require 'gdata'
require 'yaml'

class Gtool
  module Wtf # Additional namespacing is needed for nice formatting. Iunno.
  class Auth < Thor
    Gtool.register self, "auth", "auth [COMMAND]", "GData authentication operations"
    namespace :auth

    desc "generate", "Generate a token using the clientlogin method"
    method_option "debug", :type => :boolean, :desc => "Enable debug output", :aliases => "-d"
    method_option "noop",  :type => :boolean, :desc => "Enable noop mode", :aliases => "-n"
    def generate
      user = ask "Username:"
      %x{stty -echo}
      pass = ask "Password:"
      %x{stty echo}
      puts
      service = ask "Service:"

      domain  = ask "Domain:"

      authject = GData::Auth::ClientLogin.new(user, pass, service, options)
      token = authject.token

      if token.nil?
        say "Authentication failed!", :red
      else
        say "Authentication accepted, token valid till #{Time.now + (60 * 60 * 24)}", :green
        credentials = {:token => token, :created => Time.now, :domain => domain}

        File.open("#{ENV['HOME']}/.gtool.yaml", "w") do |f|
          f.write(YAML.dump(credentials))
          f.chmod 0600
        end
      end
    end

    desc "display", "Displays the cached credentials"
    def display
      settings = self.class.settings

      expiration = Time.at(settings[:created]) + (60 * 60 * 24)

      if Time.now > expiration
        say "created: #{settings[:created]} (expired)", :red
      else
        say "created: #{settings[:created]} (valid)", :green
      end
      say "token: #{settings[:token]}", :cyan
    end

    def self.settings
      settings = nil
      creds_file = "#{ENV['HOME']}/.gtool.yaml"
      begin
        File.open creds_file do |f|
          settings = YAML::load f.read
        end
      rescue Errno::ENOENT
        puts "#{creds_file} does not exist, run 'gtool auth generate'"
        exit
      end
      settings
    end

    def self.connection(options)
      connection = GData::Connection.new(settings[:domain], settings[:token], options)
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
  end
end
