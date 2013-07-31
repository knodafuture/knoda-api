class Challenge < ActiveRecord::Base
  belongs_to :user
  belongs_to :prediction

  validates :user_id, presence: true
  validates :prediction_id, presence: true

  validates_uniqueness_of :prediction_id, :scope => :user_id
  validate :prediction_is_not_expired, :on => :create
  validate :prediction_is_not_closed, :on => :create
  
  after_create :challenge_create_badges
  
  scope :own, -> {joins(:prediction).where(is_own: true).order('expires_at DESC')}
  scope :picks, -> {joins(:prediction).where(is_own: false).order('expires_at DESC')}
  scope :completed, -> {joins(:prediction).where(is_own: false, is_finished: true).order('expires_at DESC')}
  
  scope :won_picks, -> {joins(:prediction).where(is_own: false, is_finished: true, is_right: true).order('expires_at DESC')}
  scope :lost_picks, -> {joins(:prediction).where(is_own: false, is_finished: true, is_right: false).order('expires_at DESC')}
  scope :unviewed, -> {where(seen: false)}
  scope :expired, -> {joins(:prediction).where("is_closed is false and expires_at <= ?", Time.now).order("expires_at DESC")}
  
  scope :agreed_by_users, ->{where(agree: true, is_own: false).order('created_at DESC')}
  scope :disagreed_by_users, ->{where(agree: false, is_own: false).order('created_at DESC')}
  
  
  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities
  self.authorizer_name = 'ChallengeAuthorizer'

  def base_points
    if self.is_own
      # inceptive for user making the prediction
      10
    else
      # inceptive for user agreeing or disagreeing with prediction
      5
    end
  end
  
  def outcome_points
    if self.agree == self.prediction.reload.outcome
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
  
  def total_points
    p = self.base_points + self.outcome_points + self.prediction_market_points
    if self.is_own
      p += self.market_size_points
    end
    
    return p
  end
  
  def close
    self.update({is_right: (self.agree == self.prediction.outcome), is_finished: true})
    self.user.update({points: self.user.points + self.total_points})
    self.user.update_streak(self.is_right)
    self.user.save!
  end
  
  def revert
    self.user.update({points: self.user.points - self.total_points})
    self.update({is_right: false, is_finished: false, bs: false})
  end
  
  def points_details
    {
      base_points: self.base_points,
      outcome_points: self.outcome_points,
      market_size_points: self.market_size_points,
      prediction_market_points: self.prediction_market_points
    }
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
