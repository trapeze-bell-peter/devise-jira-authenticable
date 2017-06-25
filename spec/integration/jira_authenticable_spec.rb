require 'rails_helper'

include Warden::Test::Helpers

RSpec.feature 'login', type: :feature do
  include_context 'mock jira http calls'

  let!(:jirauser) { FactoryGirl.create(:jirauser) }

  it 'allows a jira user to login' do
    visit root_path
    fill_in "Username", with: jirauser.username
    fill_in "Password", with: 'password'
    click_button "Log in"
    expect( page ).to have_content 'Hello World!  Rails is running with devise-jira-authenticable.'
  end

  it 'allows a jira user to login' do
    visit root_path
    fill_in "Username", with: 'wrongname'
    fill_in "Password", with: 'password'
    click_button "Log in"
    expect( page ).not_to have_content 'Hello World!  Rails is running with devise-jira-authenticable.'
  end

  it 'fails if an admin user tries to login with the wrong password' do
    login_as jirauser, password: 'bad password'
    visit root_path
  end

=begin
  it "is successful for a database user with params authentication" do


    current_path.should == root_path
    page.should have_content("Signed in successfully")
  end

  it "is successful for a radius user with HTTP Basic Authentication" do
    page.driver.browser.basic_authorize('testuser', 'password')
    visit root_path

    current_path.should == root_path
  end

  it "is successful for a radius user with params authentication" do
    fill_in "Login", :with => 'testuser'
    fill_in "Password", :with => 'password'
    click_button "Sign in"

    current_path.should == root_path
    page.should have_content("Signed in successfully")
  end

  it "fails for wrong database password" do
    fill_in "Login", :with => @admin.email
    fill_in "Password", :with => 'password2'
    click_button "Sign in"

    current_path.should == new_admin_session_path
    page.should have_content("Invalid email or password")
  end

  it "fails for wrong radius password" do
    fill_in "Login", :with => 'testuser'
    fill_in "Password", :with => 'password2'
    click_button "Sign in"

    current_path.should == new_admin_session_path
    page.should have_content("Invalid email or password")
  end

  it "invokes the after_radius_authentication callback" do
    fill_in "Login", :with => 'testuser'
    fill_in "Password", :with => 'password'
    click_button "Sign in"

    uid = User.radius_uid_generator.call('testuser', User.radius_server)
    User.where(User.radius_uid_field => uid).count.should == 1
  end

  it "successfully logs in a user with case insensitive username" do
    swap(Devise, :case_insensitive_keys => [User.authentication_keys.first]) do
      fill_in "Login", :with => 'TESTUSER'
      fill_in "Password", :with => 'password'
      click_button "Sign in"

      current_path.should == root_path
      page.should have_content("Signed in successfully")
    end
  end

  it "fails to log in a user with case sensitive username" do
    swap(Devise, :case_insensitive_keys => []) do
      fill_in "Login", :with => 'TESTUSER'
      fill_in "Password", :with => 'password'
      click_button "Sign in"

      current_path.should == new_admin_session_path
      page.should have_content("Invalid email or password")
    end
  end

  context "when radius authentication is the first strategy" do
    before do
      @admin2 = FactoryGirl.create(:admin, :password => 'password')
      create_radius_user(@admin2.email, 'password2')

      @orig_order = Devise.warden_config.default_strategies(:scope => :admin)
      Devise.warden_config.default_strategies(:radius_authenticatable,
                                              :database_authenticatable,
                                              {:scope => :admin})
    end

    after do
      Devise.warden_config.default_strategies(@orig_order, {:scope => :admin})
    end

    it "proceeds with the next strategy if radius authentication fails" do
      fill_in "Login", :with => @admin2.email
      fill_in "Password", :with => 'password'
      click_button "Sign in"

      current_path.should == root_path
      page.should have_content("Signed in successfully")
    end
  end
=end
end
