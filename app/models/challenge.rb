class Challenge < ActiveRecord::Base
  belongs_to :user
  belongs_to :prediction

  validates :user_id, presence: true
  validates :prediction_id, presence: true
  
  validates_uniqueness_of :prediction_id, :scope => :user_id
  
  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities
  self.authorizer_name = 'ChallengeAuthorizer'
end
