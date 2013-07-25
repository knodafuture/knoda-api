class AppleDeviceToken < ActiveRecord::Base
  belongs_to :user
  validates :token, presence: true
end
