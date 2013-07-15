FactoryGirl.define do
  factory :user do
    username 'username'
    email 'username@example.com'
    password 'password'
    password_confirmation { 'password' }
  end
end
