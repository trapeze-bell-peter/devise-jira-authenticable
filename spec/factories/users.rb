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
    password { 'password' }
  end
end
