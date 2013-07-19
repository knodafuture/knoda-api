class Prediction < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :challenges, :dependent => :destroy
  has_many :voters, through: :challenges, class_name: "User", source: 'user'

  validates :body, presence: true
  validates :expires_at, presence: true
  validates :tag_list, presence: true
  validate  :max_tag_count

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
end
