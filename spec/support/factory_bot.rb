require 'factory_bot'

# Configuration for FactoryBot.
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  FactoryBot.definition_file_paths << File.expand_path('spec/factories')

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
