class Prediction < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :challenges, :dependent => :destroy
  has_many :voters, through: :challenges, class_name: "User", source: 'user'

  validates :body, presence: true
  validates :expires_at, presence: true
  validates :tag_list, presence: true
  validate  :max_tag_count

  scope :recent, :order => "predictions.created_at DESC"
  scope :expiring, lambda { { :conditions => ["predictions.expires_at >= ?", Time.now], :order => "predictions.expires_at ASC" } }
  scope :closed, lambda { { :conditions => ["predictions.expires_at < ?", Time.now], :order => "predictions.expires_at DESC" } }

  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities
  self.authorizer_name = 'PredictionAuthorizer'
  
  private
  
  def max_tag_count
    errors[:tag_list] << "1 tag maximum" if tag_list.count > 1
  end
end
