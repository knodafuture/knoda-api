class Prediction < ActiveRecord::Base
  acts_as_taggable
  
  after_create :prediction_create_badges

  belongs_to :user
  has_many :challenges, :dependent => :destroy
  has_many :voters, through: :challenges, class_name: "User", source: 'user'

  validates :body, presence: true
  validates :expires_at, presence: true
  validates :tag_list, presence: true
  validate  :max_tag_count
  validate  :tag_existence
  
  validates_length_of :body, :maximum => 300

  scope :recent, lambda {{ :conditions => ["predictions.expires_at >= current_date"], :order => "predictions.created_at DESC" } }
  scope :expiring, lambda { { :conditions => ["predictions.expires_at >= current_date"], :order => "predictions.expires_at ASC" } }

  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities
  self.authorizer_name = 'PredictionAuthorizer'

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
  
  def user_username
    self.user.username
  end
  
  def user_avatar_image
    self.user.avatar_image
  end

  def disagreed_count
    self.challenges.find_all_by_agree(false).count
  end

  def agreed_count
    self.challenges.find_all_by_agree(true).count + 1
  end
  
  
  def ratio
    prediction_market.round
  end

  def prediction_market
    total = self.challenges.count  + 1
    positive = self.agreed_count
    
    (positive.to_f / total) * 100.0
  end

  private

  def max_tag_count
    errors[:tag_list] << "1 tag maximum" if tag_list.count > 1
  end
  
  def tag_existence
    tag_list.each do |tag_name|
      if Topic.where(name: tag_name).first.nil?
        errors[:tag_list] << "invalid tag #{tag_name}"
      end
    end
  end
  
  def prediction_create_badges
    self.user.prediction_create_badges
  end
end
