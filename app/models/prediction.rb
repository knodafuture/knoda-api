class Prediction < ActiveRecord::Base
  acts_as_taggable

  belongs_to :user
  has_many :challenges, :dependent => :destroy
  has_many :voters, through: :challenges, class_name: "User", source: 'user'

  validates :body, presence: true
  validates :expires_at, presence: true
  validates :tag_list, presence: true

  scope :recent, :order => "predictions.created_at DESC"
  scope :expiring, lambda { { :conditions => ["predictions.expires_at >= ?", Time.now], :order => "predictions.expires_at ASC" } }
  scope :closed, lambda { { :conditions => ["predictions.expires_at < ?", Time.now], :order => "predictions.expires_at DESC" } }

  # Adds `creatable_by?(user)`, etc
  include Authority::Abilities
  self.authorizer_name = 'PredictionAuthorizer'
end
