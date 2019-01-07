require 'factory_bot'

# Configuration for FactoryBot.
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Add any directories directly underneath spec/factories to the FactoryBot path.
  Dir.entries(File.join(Rails.root, '../factories')).select do |f|
    FactoryBot.definition_file_paths.add(f) if File.directory?(f) && f !~ /.*/
  end
end
