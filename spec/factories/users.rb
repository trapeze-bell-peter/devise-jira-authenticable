FactoryGirl.define do
=begin
  sequence :username do |n|
    "jira_user#{n}"
  end

  factory :user do
    username
    email    { "#{username}@test.com" }
    password 'password'
  end
=end

  factory :user do
    username { 'testuser' }
    email    { 'testuser@testsite.com' }
    password { 'password' }

    factory :admin do
      username { 'admin' }
      email    { 'admin@testsite.com' }
      password { 'password' }
    end
  end
end
