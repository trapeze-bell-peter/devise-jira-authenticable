require 'rails_helper'

include Warden::Test::Helpers

RSpec.feature 'login', type: :feature do
  include_context 'mock jira http calls'

  let!(:jirauser) do
    FactoryBot.create(:jirauser)
  end

  it 'allows a jira user to login' do
    visit root_path
    fill_in "Username", with: jirauser.username
    fill_in "Password", with: 'password'
    click_button "Log in"
    expect( page ).to have_content 'Hello World! Rails is running with devise-jira-authenticable.'
  end

  it 'allows a jira user to login' do
    visit root_path
    fill_in "Username", with: 'wrongname'
    fill_in "Password", with: 'password'
    click_button "Log in"
    expect( page ).not_to have_content 'Hello World! Rails is running with devise-jira-authenticable.'
  end

  it 'fails if an admin user tries to login with the wrong password' do
    login_as jirauser, password: 'bad password'
    visit root_path
  end
end
