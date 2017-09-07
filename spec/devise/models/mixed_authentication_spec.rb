require 'rails_helper'

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

  let!(:dbuser) { FactoryGirl.create(:dbuser) }
  let!(:jirauser) { FactoryGirl.create(:jirauser) }
  let(:auth_key) { Devise.authentication_keys.first }

  it "will allow the dbuser's password to be set" do
    expect(User.find_by(username: 'dbuser').encrypted_password).not_to be_blank
  end

  context 'jira authenticated user' do
    let(:good_auth_hash) { {username: 'testuser', password: 'password'} }
    let(:bad_auth_hash) { {username: 'testuser', password: 'wrongpassword'} }

    it 'uses the existing user record when one is found' do
      expect(User.find_for_jira_authentication(good_auth_hash)).to eq(jirauser)
    end

    it 'fails if a bad password is provided' do
      expect(User.find_for_jira_authentication(bad_auth_hash)).to be_nil
    end
  end

  context 'database authenticated user' do
    let(:good_auth_hash) { {username: 'testuser', password: 'password'} }
    let(:bad_auth_hash) { {username: 'testuser', password: 'wrongpassword'} }

    it 'uses the existing user record when one is found' do
      expect(User.find_for_jira_authentication(good_auth_hash)).to eq(jirauser)
    end

    it 'fails if a bad password is provided' do
      expect(User.find_for_jira_authentication(bad_auth_hash)).to be_nil
    end
  end
end
