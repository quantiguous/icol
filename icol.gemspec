$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "icol/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "icol"
  s.version     = Icol::VERSION
  s.authors     = ["divyajayan"]
  s.email       = ["divya.jayan@quantiguous.com"]
  s.homepage    = "http://www.quantiguous.com"
  s.summary     = "APIBanking: Icollect"
  s.description = "APIBanking: Icollect"
  s.license     = "Commercial"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "4.2.2"
  s.add_dependency 'approval2', '0.1.7'
  s.add_dependency 'cancancan', '1.12.0'
  s.add_dependency 'responders', '2.1.0'
  s.add_dependency 'devise', '>= 2.2.3'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails", "2.14.0"
  s.add_development_dependency "spork", "> 0.9.0.rc"
  s.add_development_dependency "webmock"
  s.add_development_dependency "codeclimate-test-reporter", "0.5.0"
  s.add_development_dependency "factory_girl", "2.2.0"
  s.add_development_dependency 'database_cleaner', '< 1.1.0'
  s.add_development_dependency 'flexmock'
  s.add_development_dependency 'shoulda-matchers', '2.8.0'
  s.add_development_dependency 'test-unit'
end
