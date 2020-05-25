# frozen_string_literal: true

require 'rails_helper'
require 'shared_contexts/mocked_http_client'

RSpec.feature 'login', type: :feature do
  include Warden::Test::Helpers

  include_context 'mock jira http calls'

  let!(:jirauser) do
    FactoryBot.create(:jirauser)
  end

  it 'allows a jira user to login' do
    visit root_path
    fill_in 'Username', with: jirauser.username
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(page).to have_content 'Hello World! Rails is running with devise-jira-authenticable.'
  end

  it 'prevents a jira user with the wrong password from logging in' do
    visit root_path
    fill_in 'Username', with: 'wrongname'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(page).not_to have_content 'Hello World! Rails is running with devise-jira-authenticable.'
  end

  it 'fails if an admin user tries to login with the wrong password' do
    login_as jirauser, password: 'bad password'
    visit root_path
  end
end
