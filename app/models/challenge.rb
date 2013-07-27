class Challenge < ActiveRecord::Base
  belongs_to :user
  belongs_to :prediction

  validates :user_id, presence: true
  validates :prediction_id, presence: true

  validates_uniqueness_of :prediction_id, :scope => :user_id
  #validate :prediction_is_not_expired
  #validate :prediction_is_not_closed
  
  after_create :challenge_create_badges
  
  scope :own, -> {joins(:prediction).where(is_own: true).order('expires_at DESC')}
  scope :picks, -> {joins(:prediction).where(is_own: false).order('expires_at DESC')}
  scope :completed, -> {joins(:prediction).where(is_own: false, is_finished: true).order('expires_at DESC')}

  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities
  self.authorizer_name = 'ChallengeAuthorizer'
  
  def self.get_own(id)
    Challenge.joins(:prediction)
      .where(user_id: id)
      .where(is_own: true)
      .order('expires_at DESC')
  end

  def self.get_notifications_by_user_id(id)
    Challenge.joins(:prediction)
             .where(seen: false)
             .where(user_id: id)
             .where(is_own: false)
             .where("predictions.closed_at IS NOT NULL OR (predictions.closed_at IS NULL AND expires_at < current_date)")
             .order("CASE when closed_at IS NOT NULL then closed_at else expires_at end desc")
  end
  
  def outcome_points
    if self.agree == self.prediction.outcome
      10
    else
      0
    end
  end
  
  def market_size_points
    self.prediction.market_size_points
  end
  
  def prediction_market_points
    self.prediction.prediction_market_points
  end
  
  def close
    self.is_right = self.agree == self.prediction.outcome
    self.is_finished = true
    self.save!
    
    self.user.points += self.prediction_market_points
    self.user.points += self.outcome_points
    
    if self.is_own
      self.user.points += self.market_size_points
    end
    
    self.user.update_streak(self.is_right)
    self.user.save!
  end
  
  def revert!
    self.is_right = false
    self.is_finished = false
    self.bs = false
    self.save!
 
    k = 0
    k = k + self.prediction_market_points
    k = k + self.outcome_points
    if self.is_own?
      k = k + self.market_size_points
    end
    
    self.user.points = self.user.points - k    
    self.user.save!
  end

  private

  def prediction_is_not_expired
    errors[:prediction] << "prediction is expired" if self.prediction.expires_at.past?
  end

  def prediction_is_not_closed
    errors[:prediction] << "prediction is closed" if !self.prediction.closed_at.nil?
  end
  
  def challenge_create_badges
    self.user.challenge_create_badges
  end
end
