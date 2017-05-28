FactoryGirl.define do
  sequence :username do |n|
    "jira_user#{n}"
  end

  factory :user do
    username
    email    { "#{username}@test.com" }
    password 'password'
  end
end
