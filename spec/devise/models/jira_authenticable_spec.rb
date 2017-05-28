require 'rails_helper'

class Configurable < User
  devise(:jira_authenticable, jira_site: 'localhost', jira_context_path: '')
end

describe Devise::Models::JiraAuthenticable do
  let(:auth_key) { Devise.authentication_keys.first }

  it 'allows configuration of the JIRA server URL' do
    expect(Configurable.jira_site).to eq 'localhost'
  end

  it 'allows configuration of the JIRA context path' do
    expect(Configurable.jira_context_path).to be_blank
  end

  it 'allows configuration of the JIRA server timeout' do
    expect(Configurable.jira_read_timeout).to eq(60)
  end

=begin
  it "converts the username to lower case if the key is case insensitive" do
    swap(Devise, {:authentication_keys => [:username, :domain],
           :case_insensitive_keys => [:username]}) do
      auth_hash = { :username => 'Cbascom', :password => 'testing' }
      Configurable.radius_credentials(auth_hash).should == ['cbascom', 'testing']
    end
  end

  it "does not convert the username to lower case if the key is not case insensitive" do
    swap(Devise, {:authentication_keys => [:username, :domain],
           :case_insensitive_keys => []}) do
      auth_hash = { :username => 'Cbascom', :password => 'testing' }
      Configurable.radius_credentials(auth_hash).should == ['Cbascom', 'testing']
    end
  end

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
    before do
      @user = User.new
      setup_http_client_mocks
    end

    it "passes the configured options when building the radius request" do

      @user.valid_jira_password?('testuser', 'password')

      expect(jira_client.jira_site).to 'localhost'
      radius_server.options[:reply_timeout].should == User.radius_server_timeout
      radius_server.options[:retries_number].should == User.radius_server_retries
      radius_server.options[:dict].should be_a(Radiustar::Dictionary)
    end

    it 'returns false when the password is incorrect' do
      expect(@user.valid_jira_password?('testuser', 'wrongpassword')).to be_falsey
    end

    it 'returns true when the password is correct' do
      expect(@user.valid_jira_password?('testuser', 'password')).to be_truthy
    end

    it 'stores the client in the model' do
      @user.valid_jira_password?('testuser', 'password')
      expect(@user.jira_client).to eq(jira-clients.attributes('testuser'))
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
