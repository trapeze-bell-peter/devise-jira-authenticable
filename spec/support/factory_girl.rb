require 'factory_girl'

# Configuration for FactoryGirl.
RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  # Add any directories directly underneath spec/factories to the FactoryGirl path.
  Dir.entries(File.join(Rails.root, '../factories')).select do |f|
    FactoryGirl.definition_file_paths.add(f) if File.directory?(f) && f !~ /.*/
  end
end
