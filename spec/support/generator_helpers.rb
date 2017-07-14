module GeneratorHelpers
  DESTINATION_PATH = File.expand_path("../../../tmp/dummy_app", __FILE__)
  FIXTURES_PATH = File.expand_path("../../fixtures", __FILE__)

  def generate_sample_app
    FileUtils.rm_r DESTINATION_PATH if File.exists? DESTINATION_PATH

    FileUtils.cd(Pathname.new(DESTINATION_PATH).split[0]) do
      system "rails new dummy_app --skip-active-record --skip-test-unit --skip-spring --skip-bundle"
    end

    FileUtils.cp(File.join(FIXTURES_PATH, 'Gemfile'), File.join(DESTINATION_PATH))
  end

  def prepare_devise
    FileUtils.rm_r DESTINATION_PATH
    initializers_path = File.join(DESTINATION_PATH, 'config/initializers')
    FileUtils.mkpath(initializers_path)
    FileUtils.cp(File.join(FIXTURES_PATH, 'devise.rb'), initializers_path)
  end
end

RSpec::configure do |c|
  c.include GeneratorHelpers, :type => :generator, :file_path => /spec[\\\/]generators/
  c.include GeneratorHelpers, type: :feature, file_path: /spec[\\\/]integration/
end
