
require 'rails_helper'
require 'shared_contexts/mocked_http_client'

# In certain circumstances we might have users authenticated via JIRA and others authenticated via the database.
# These specs test that database authentication (including password reset) can work alongside JIRA authentication.
describe Devise::Models::JiraAuthenticable do
  before(:all) do
    class User < ApplicationRecord
      # Note, will pick up the standard configutation from the Rail apps config/initializers/devise.rb
      devise :jira_authenticable, :database_authenticatable, :recoverable, :rememberable, :trackable,
             :validatable, :registerable
    end
  end

  include_context 'mock jira http calls'

  let!(:dbuser) { FactoryBot.create(:dbuser) }
  let!(:jirauser) { FactoryBot.create(:jirauser) }
  let(:auth_key) { Devise.authentication_keys.first }

  it "will allow the dbuser's password to be set" do
    expect(User.find_by(username: 'dbuser').encrypted_password).not_to be_blank
  end

  context 'jira authenticated user' do
    it 'validates correctly against JIRA if a valid password is provided' do
      expect(jirauser.valid_jira_password?('password')).to be_truthy
    end

    it 'fails to validate against the database password' do
      expect(jirauser.valid_password?('password')).to be_falsey
    end

    it 'fails to validate against JIRA if a bad password is provided' do
      expect(jirauser.valid_jira_password?('wrongpassword')).to be_falsey
    end
  end

  context 'database authenticated user' do
    it 'validates against the database if a valid password is provided' do
      expect(dbuser.valid_password?('dbpassword')).to be_falsey
    end

    it 'fails to validate against JIRA' do
      expect(dbuser.valid_jira_password?('dbpassword')).to be_falsey
    end

    it 'fails to validate against the database if a bad password is provided' do
      expect(dbuser.valid_password?('wrongpassword')).to be_falsey
    end
  end
end
