ENV["RAILS_ENV"] ||= 'test'

require 'devise/jira_authenticable'

require 'rails_app/config/environment'

require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'factory_girl'

# Load in all of our supporting code
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each {|f| require f}

# Make sure to get the database migrated
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Migrator.migrate(File.expand_path("../rails_app/db/migrate/", __FILE__))

# RSpec Configuration
RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.include_context 'mock jira http calls', :include_shared => true
end