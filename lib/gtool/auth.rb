require 'gtool'
require 'gtool/util/ask_default'
require 'gprov'
require 'yaml'
require 'osx_keychain'

module Gtool
  class Auth < Thor
    include Gtool::Util
    Gtool::CLI.register self, "auth", "auth [COMMAND]", "GProv authentication operations"
    namespace :auth

    TOKEN_DURATION = 60 * 60 * 24 * 14

    desc "generate", "Generate a token using the clientlogin method"
    method_option "debug", :type => :boolean, :desc => "Enable debug output", :aliases => "-d"
    method_option "noop",  :type => :boolean, :desc => "Enable noop mode", :aliases => "-n"
    def generate
      user = ask "Username:"
      %x{stty -echo}

      pass = nil
      keychain = OSXKeychain.new
      pass = keychain['gtool',user]
      unless pass
        pass = ask "Password:"
      end

      %x{stty echo}
      puts

      service = ask_default "apps", "Service (defaults to apps):"

      domain  = ask "Domain:"

      authject = GProv::Auth::ClientLogin.new(user, pass, service, options)
      token = authject.token

      if token.nil?
        say "Authentication failed!", :red
      else
        keychain.set('gtool',user,pass)
        say "Authentication accepted, token valid till #{Time.now + TOKEN_DURATION}", :green
        credentials = {:user => user, service => service, :token => token, :created => Time.now, :domain => domain}

        File.open("#{ENV['HOME']}/.gtool.yaml", "w") do |f|
          f.write(YAML.dump(credentials))
          f.chmod 0600
        end
      end
    end

    desc "display", "Displays the cached credentials"
    def display
      settings = self.class.settings

      expiration = Time.at(settings[:created]) + TOKEN_DURATION

      if Time.now > expiration
        say "created: #{settings[:created]} (expired)", :red
      else
        say "created: #{settings[:created]} (valid)", :green
        say "expires: #{expiration}", :green
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
      connection = GProv::Connection.new(settings[:domain], settings[:token], options)
    end

    def self.banner(task, namespace = true, subcommand = false)
      "#{basename} #{task.formatted_usage(self, true, subcommand)}"
    end
  end
end
