FactoryGirl.define do
  factory :admin do
    username { 'admin' }
    email    { 'admin@testsite.com' }
    password { 'password' }
  end
end
