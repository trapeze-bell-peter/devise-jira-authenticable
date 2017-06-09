require 'rails_helper'

class Configurable < User
  # Note, will pick up the standard configutation from the Rail apps config/initializers/devise.rb
  devise(:jira_authenticable)
end

describe Devise::Models::JiraAuthenticable do
  let(:auth_key) { Devise.authentication_keys.first }

  it 'allows configuration of the JIRA server URL' do
    expect(Configurable.jira_site).to eq 'https://localhost:2990'
  end

  it 'allows configuration of the JIRA context path' do
    expect(Configurable.jira_context_path).to eq '/jira'
  end

  it 'allows configuration of the JIRA server timeout' do
    expect(Configurable.jira_read_timeout).to eq(60)
  end

=begin
  context "when finding the user record for authentication" do
    let(:good_auth_hash) { {auth_key => 'testuser', :password => 'password'} }
    let(:bad_auth_hash) { {auth_key => 'testuser', :password => 'wrongpassword'} }

    before do
      @uid_field = User.radius_uid_field.to_sym
      @uid = User.radius_uid_generator.call('testuser', User.radius_server)
      create_radius_user('testuser', 'password')
    end

    it "uses the generated uid and configured uid field to find the record" do
      User.should_receive(:find_for_authentication).with(@uid_field => @uid)
      User.find_for_radius_authentication(good_auth_hash)
    end

    context "and authentication succeeds" do
      it "creates a new user record if none was found" do
        User.find_for_radius_authentication(good_auth_hash).should be_new_record
      end

      it "fills in the uid when creating the new record" do
        admin = User.find_for_radius_authentication(good_auth_hash)
        admin.send(@uid_field).should == @uid
      end

      it "uses the existing user record when one is found" do
        admin = FactoryGirl.create(:admin, @uid_field => @uid)
        User.find_for_radius_authentication(good_auth_hash).should == admin
      end
    end

    context "and authentication fails" do
      it "does not create a new user record" do
        User.find_for_radius_authentication(bad_auth_hash).should be_nil
      end
    end
  end
=end

  context "when validating a JIRA user's password" do
    include_context 'mock jira http calls'

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

    context "when handle_radius_timeout_as_failure is false" do
      it "does not catch the RuntimeError exception" do
        Radiustar::Request.any_instance.stub(:authenticate).
          and_raise(RuntimeError)
        expect { @admin.valid_radius_password?('testuser', 'password') }.
          to raise_error(RuntimeError)
      end
    end

=begin
    context "when handle_radius_timeout_as_failure is true" do
      it "returns false when the authentication times out" do
        swap(Devise, :handle_radius_timeout_as_failure => true) do
          Radiustar::Request.any_instance.stub(:authenticate).
            and_raise(RuntimeError)
          @admin.valid_radius_password?('testuser', 'password').should be_false
        end
      end
    end
=end
  end
end
