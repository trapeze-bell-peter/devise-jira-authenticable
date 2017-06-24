require 'rails_helper'



describe Devise::Models::JiraAuthenticable do
  before(:all) do
    class User
      # Note, will pick up the standard configutation from the Rail apps config/initializers/devise.rb
      devise(:jira_authenticable)
    end
  end

  include_context 'mock jira http calls'

  let(:auth_key) { Devise.authentication_keys.first }

  it 'allows configuration of the JIRA server URL' do
    expect(Devise.jira_site).to eq 'https://localhost:2990'
  end

  it 'allows configuration of the JIRA context path' do
    expect(Devise.jira_context_path).to eq '/jira'
  end

  it 'allows configuration of the JIRA server timeout' do
    expect(Devise.jira_read_timeout).to eq(120)
  end

  context "when finding the user record for authentication" do
    let(:good_auth_hash) { {username: 'testuser', password: 'password'} }
    let(:bad_auth_hash) { {username: 'testuser', password: 'wrongpassword'} }

    it "uses the username and password to find the record" do
      expect(User).to receive(:find_for_authentication).with(username: 'testuser')
      User.find_for_jira_authentication(good_auth_hash)
    end

    context "and authentication succeeds" do
      it "creates a new user record if none was found" do
        expect(User.find_for_jira_authentication(good_auth_hash)).to be_new_record
      end

      it "uses the existing user record when one is found" do
        user = FactoryGirl.create(:user)
        expect(User.find_for_jira_authentication(good_auth_hash)).to eq(user)
      end
    end

    context "and authentication fails" do
      it "does not create a new user record" do
        expect(User.find_for_jira_authentication(bad_auth_hash)).to be_nil
      end
    end
  end

  context "when validating a JIRA user's password" do
    it 'returns false when the password is incorrect' do
      expect(example_user.valid_jira_password?(example_user.username, 'wrongpassword')).to be_falsey
    end

    it 'returns true when the password is correct' do
      expect(example_user.valid_jira_password?(example_user.username, example_user.password)).to be_truthy
    end

    it 'stores the client in the model' do
      example_user.valid_jira_password?(example_user.username, example_user.password)
      expect(example_user.jira_client.Project.all).to be_empty
    end

    context('and a timeout occurs') do
      before do
        stub_request(:post, 'https://localhost:2990/jira/rest/auth/1/session')
          .with(body: "{\"username\":\"#{example_user.username}\",\"password\":\"#{example_user.password}\"}")
          .to_timeout
      end

      it "catches the RuntimeError exception if handle_jira_timeout_as_failure is false" do
        expect { example_user.valid_jira_password?('testuser', 'password') }.to raise_error(RuntimeError)
      end

      it 'returns nil if handle_jira_timeout_as_failure is true' do
        swap(Devise, handle_jira_timeout_as_failure: true) do
          expect(example_user.valid_jira_password?('testuser', 'password')).to be_nil
        end
      end
    end
  end
end
