begin
  require 'thor'
  require 'thor/group'
rescue LoadError
  require 'rubygems'
  require 'thor'
  require 'thor/group'
end

class Gtool < Thor

end
require 'gtool/auth'
require 'gtool/provision/user'
require 'gtool/provision/group'
