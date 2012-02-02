begin
  require 'thor'
  require 'thor/group'
rescue LoadError
  require 'rubygems'
  require 'thor'
  require 'thor/group'
end

require 'gtool/version'
require 'gtool/cli'
require 'gtool/auth'
require 'gtool/provision/user'
require 'gtool/provision/group'
require 'gtool/provision/customerid'
require 'gtool/provision/orgunit'
require 'gtool/provision/orgmember'
