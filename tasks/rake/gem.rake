require 'rubygems'
require 'rubygems/package_task'

BIN_FILES = Dir["bin/*"]
LIB_FILES = Dir["lib/**/*"]
DOC_FILES = Dir["[A-Z]*"]

PKG_FILES = BIN_FILES + LIB_FILES + DOC_FILES

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'gtool'
  s.author = 'Adrien Thebo'
  s.email  = 'adrien@puppetlabs.com'
  s.homepage = 'http://github.com/adrienthebo/gtool'
  s.files = PKG_FILES
  s.executables << 'gtool'
  s.summary = "Command line interface to the Google Provisioning API"
  s.description = "All the fun of Google Provisioning, none of the HTML"
  s.version = Gtool::VERSION
  s.add_dependency('gprov', ">= 0.0.2")
  s.add_dependency('thor', ">= 0.14")
  s.require_path = 'lib'
end

Gem::PackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end
