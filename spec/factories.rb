FactoryGirl.define do

  sequence :prediction_id do |n|
    n
  end

  sequence :username do |n|
    "#{Faker::Name.first_name}#{n}"
  end

  sequence :body do |n|
    "Prediction #{n}"
  end

  factory :user do
    username
    email { Faker::Internet.email }
    password 'password'
    password_confirmation { 'password' }
  end

  factory :prediction do
    user_id 1
    body { FactoryGirl.generate(:body) }
    expires_at Date.new(2014, 9, 1)
    outcome true
    tag_list 'test'
  end

  factory :challenge do
    user_id 1
    prediction_id
  end
end
