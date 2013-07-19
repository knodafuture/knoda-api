class Challenge < ActiveRecord::Base
  belongs_to :user
  belongs_to :prediction

  validates :user_id, presence: true
  validates :prediction_id, presence: true

  validates_uniqueness_of :prediction_id, :scope => :user_id
  validate :prediction_is_not_expired
  validate :prediction_is_not_closed

  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities
  self.authorizer_name = 'ChallengeAuthorizer'

  def self.get_notifications_by_user_id(id)
    Challenge.joins(:prediction)
             .where(seen: false)
             .where(user_id: id)
             .where("predictions.closed_at IS NOT NULL OR (predictions.closed_at IS NULL AND expires_at < current_date)")
             .order("CASE when closed_at IS NOT NULL then closed_at else expires_at end desc")
  end

  private

  def prediction_is_not_expired
    errors[:prediction] << "prediction is expired" if self.prediction.expires_at.past?
  end

  def prediction_is_not_closed
    errors[:prediction] << "prediction is closed" if !self.prediction.closed_at.nil?
  end
end
