FactoryGirl.define do
  factory :user do
    factory :admin do
      username { 'admin' }
      email    { 'admin@testsite.com' }
      password { 'password' }
    end
    factory :jirauser do
      username { 'testuser' }
    end
  end
end
