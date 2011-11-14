require 'thor'
require 'gdata'
require 'yaml'

class Gtool
  module Auth
    class ClientLogin < Thor::Group
      Gtool.register self, "clientlogin", "clientlogin", "Generate a token using the clientlogin method"

      def token
        user = ask "Username:"
        %x{stty -echo}
        pass = ask "Password:"
        %x{stty echo}
        puts
        service = ask "Service:"

        domain  = ask "Domain:"

        authject = GData::Auth::ClientLogin.new(user, pass, service)
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
    end
  end
end
