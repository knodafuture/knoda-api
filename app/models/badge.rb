class Badge < ActiveRecord::Base
  belongs_to :user
  
  scope :unseen, -> {where(seen: false)}
end
