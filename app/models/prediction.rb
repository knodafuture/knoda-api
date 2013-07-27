class Prediction < ActiveRecord::Base
  acts_as_taggable
  
  include Authority::Abilities
  self.authorizer_name = 'PredictionAuthorizer'
  
  after_create :prediction_create_badges
  after_create :create_own_challenge

  belongs_to :user
  
  has_many :challenges, :dependent => :destroy
  has_many :voters, through: :challenges, class_name: "User", source: 'user'

  validates :body, presence: true
  validates :expires_at, presence: true

  validates :tag_list, presence: true
  validate  :max_tag_count
  validate  :tag_existence
  validate  :expires_at_is_not_past, :on => :create
  validate  :new_expires_at_is_not_past, :on => :update
  
  validates_length_of :body, :maximum => 300
  validates_uniqueness_of :body

  scope :recent, lambda {{ :conditions => ["predictions.expires_at >= current_date"], :order => "predictions.created_at DESC" } }
  scope :expiring, lambda { { :conditions => ["predictions.expires_at >= current_date"], :order => "predictions.expires_at ASC" } }
  
  scope :latest, -> { order('created_at DESC') }
  
  def self.recent_by_user_id(id)
    Prediction.where(user_id: id.to_s)
              .where("expires_at >= current_date")
              .order("created_at DESC")
  end

  def self.closed_by_user_id(id)
    Prediction.where(user_id: id.to_s)
              .where("closed_at IS NOT NULL")
              .order("created_at DESC")
  end

  def disagreed_count
    self.challenges.find_all_by_agree(false).count
  end

  def agreed_count
    self.challenges.find_all_by_agree(true).count
  end
  
  def market_size
    self.challenges.count
  end
  
  def prediction_market
    (self.agreed_count.fdiv(self.market_size) * 100.0).round(2)
  end
  
  def market_size_points
    case self.market_size
      when 0..5
        0
      when 6..20
        10
      when 21..100
        20
      when 101..500
        30
      when 501..(1.0/0.0)
        40
    end
  end
  
  def prediction_market_points
    case self.prediction_market
      when 0.0..15.00
        50
      when 15.00..30.00
        40
      when 30.00..50.00
        30
      when 50.00..75.00
        20
      when 75.00..95.00
        10
      when 95.00..100.00
        0
    end
  end
  
  def close_as(outcome)
    self.outcome = outcome
    self.is_closed = true
    self.closed_at = Time.now
    return false unless self.save
    
    self.user.outcome_badges
    self.challenges.each do |challenge|
      challenge.close
    end
  end
  
  def revert
    self.challenges.each do |challenge|
      challenge.revert
    end
    
    self.close_as(!self.outcome)
  end
  
  def request_for_bs
    bs_count = self.challenges.where(bs: true).count
    if bs_count.fdiv(self.challenges.count-1) >= 25.00
      self.revert
      true
    else
      false
    end
  end

  private
  
  def expires_at_is_not_past
    return unless self.expires_at
    errors[:expires_at] << "is past" if self.expires_at.past?
  end
  
  def new_expires_at_is_not_past
    if self.expires_at_changed?
      errors[:expires_at] << "is past" if self.expires_at.past?
    end
  end

  def max_tag_count
    errors[:tag_list] << "1 tag maximum" if self.tag_list.count > 1
  end
  
  def tag_existence
    self.tag_list.each do |tag_name|
      if Topic.where(name: tag_name).first.nil?
        errors[:tag_list] << "invalid tag #{tag_name}"
      end
    end
  end
  
  def create_own_challenge
    self.challenges.create!(user: self.user, agree: true, is_own: true)
  end
  
  def prediction_create_badges
    self.user.prediction_create_badges
  end
end
