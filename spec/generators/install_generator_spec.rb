require 'rails_helper'

require 'generators/devise_jira_authenticable/install_generator'

describe DeviseJiraAuthenticable::InstallGenerator, type: :generator do
  destination File.expand_path('../../../tmp', __FILE__)

  before do
    prepare_devise
  end

  it "requires the JIRA URL to be specified" do
    expect{ run_generator }.to raise_error(Thor::RequiredArgumentMissingError, /required arguments 'jira_site'/)
  end

  context "with required arguments" do
    before do
      run_generator ['https://testhost/']
    end

    context 'initializer' do
      subject { file('config/initializers/devise.rb') }

      context "with default options" do
        it { is_expected.to exist }
        it { is_expected.to contain('==> Configuration for jira_authenticable') }
        it { is_expected.to contain("config.jira_site = 'https://testhost/'") }
        it { is_expected.to contain("# config.jira_context_path = '/jira_context_path'") }
        it { is_expected.to contain("# config.jira_read_timeout = 99") }
        it { is_expected.to contain("# config.handle_jira_timeout_as_failure = true") }
      end
    end

    context 'the migration' do
      subject { migration_file('db/migrate/jira_authenticable_create_jira_user.rb') }

      # is_expected_to be_a_migration - verifies the file exists with a migration timestamp as part of the filename
      it { is_expected.to exist }
      it { is_expected.to contain /create_table/ }
    end

    context 'the model' do
      subject { file('app/models/jira_user.rb') }

      it { is_expected.to exist }
      it { is_expected.to contain /JiraUser/ }
    end
  end
end
