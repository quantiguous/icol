$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "icol/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "icol"
  s.version     = Icol::VERSION
  s.authors     = ["divyajayan"]
  s.email       = ["divya.jayan@quantiguous.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Icol."
  s.description = "TODO: Description of Icol."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "sqlite3"
end
