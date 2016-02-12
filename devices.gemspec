$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "devices/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "devices"
  s.version     = Devices::VERSION
  s.authors     = ["Arturo Puente"]
  s.email       = ["arturopuentevc@gmail.com"]
  s.homepage    = "https://github.com/platanus/devices"
  s.summary     = "Manage push notification enabled devices"
  s.description = "Manage push notification enabled devices"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.5.1"

  s.add_development_dependency "sqlite3"
end
