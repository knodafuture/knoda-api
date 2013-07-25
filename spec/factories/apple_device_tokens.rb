# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :apple_device_token do
    user_id 1
    token "MyString"
  end
end
