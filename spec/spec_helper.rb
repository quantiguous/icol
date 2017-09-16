# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spork'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Spork.prefork do
  WebMock.disable_net_connect!(:allow => "codeclimate.com")
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start

  ENV["RAILS_ENV"] ||= 'test'
  require 'factory_girl'
  Spork.trap_class_method(FactoryGirl, :find_definitions)
  require 'database_cleaner'
  # Spork.trap_class_method(FactoryGirl, :find_definitions)
  require File.expand_path("../dummy/config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :flexmock

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    dbs = [ DatabaseCleaner[:active_record, { :connection => :fcr_test }],
            DatabaseCleaner[:active_record, { :connection => :fcatrt_test }],
            DatabaseCleaner[:active_record, { :connection => :atom_test }],
            DatabaseCleaner[:active_record, { :connection => :upi_test }],
            DatabaseCleaner[:active_record, { :connection => :invxp_test }],
            DatabaseCleaner[:active_record, { :connection => :test }]
          ]

    config.before(:suite) do
      begin
        dbs.each do |db|
          db.strategy = :truncation
          db.start
        end
      ensure
        dbs.each do |db|
          db.clean
        end
      end
    end    
  end
end
Spork.each_run do
end

Spork.each_run do
  ActiveSupport::Dependencies.clear
  ActiveRecord::Base.instantiate_observers
  load "#{Rails.root}/config/routes.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }
end if Spork.using_spork?

module DisableFlashSweeping
  def sweep
  end
end
