require 'rails_helper'
require 'shared_contexts/mocked_http_client'

describe Devise::Models::JiraAuthenticable do
  before(:all) do
    class User < ApplicationRecord
      # Note, will pick up the standard configutation from the Rail apps config/initializers/devise.rb
      devise :jira_authenticable, :database_authenticatable
    end
  end

  include_context 'mock jira http calls'

  let(:auth_key) { Devise.authentication_keys.first }

  describe 'configuration' do
    it 'allows configuration of the JIRA server URL' do
      expect(Devise.jira_site).to eq 'https://remotejira.com'
    end

    it 'allows configuration of the JIRA context path' do
      expect(Devise.jira_context_path).to eq '/jira'
    end

    it 'allows configuration of the JIRA server timeout' do
      expect(Devise.jira_read_timeout).to eq(120)
    end
  end

  context 'when finding the jirauser record for authentication' do
    let(:good_auth_hash) { { username: 'testuser', password: 'password' } }
    let(:bad_auth_hash) { { username: 'testuser', password: 'wrongpassword' } }

    it 'uses the existing user record when one is found' do
      user = FactoryBot.create(:jirauser)
      expect(User.find_for_jira_authentication(good_auth_hash)).to eq(user)
    end

    it 'fails if a bad password is provided' do
      expect(User.find_for_jira_authentication(bad_auth_hash)).to be_nil
    end

    it 'fails if the user has not been created' do
      expect(User.find_for_jira_authentication(good_auth_hash)).to be_nil
    end
  end

  context "when validating a JIRA user's password" do
    it 'returns false when the password is incorrect' do
      expect(example_user.valid_jira_password?('wrongpassword')).to be_falsey
    end

    it 'returns true when the password is correct' do
      expect(example_user.valid_jira_password?('password')).to be_truthy
    end

    it 'stores the client in the model' do
      example_user.valid_jira_password?('password')
      expect(example_user.jira_client.Project.all).to be_empty
    end

    context('and a timeout occurs') do
      before do
        stub_request(:post, 'https://remotejira.com/jira/rest/auth/1/session')
          .with(body: "{\"username\":\"#{example_user.username}\",\"password\":\"password\"}")
          .to_timeout
      end

      it 'catches the RuntimeError exception if handle_jira_timeout_as_failure is false' do
        expect { example_user.valid_jira_password?('password') }.to raise_error(RuntimeError)
      end

      it 'returns nil if handle_jira_timeout_as_failure is true' do
        swap(Devise, handle_jira_timeout_as_failure: true) do
          expect(example_user.valid_jira_password?('password')).to be_nil
        end
      end
    end
  end
end
