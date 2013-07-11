class Challenge < ActiveRecord::Base

belongs_to :user
belongs_to :prediction

validates :user_id, presence: true
validates :prediction_id, presence: true

end
