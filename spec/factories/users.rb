FactoryBot.define do
  factory :user do
    factory :dbuser do
      username { 'dbuser' }
      email    { 'dbuser@testsite.com' }
      password { 'db-password' }
    end

    factory :jirauser do
      username { 'testuser' }
      email    { 'testuser@testsite.com' }
      password { 8.times.map { [*'0'..'9', *'a'..'z'].sample }.join }
    end
  end
end
