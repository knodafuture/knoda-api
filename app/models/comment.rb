class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :prediction

  validates :user_id, presence: true
  validates :prediction_id, presence: true
  
  include Authority::Abilities
  self.authorizer_name = 'CommentAuthorizer'

  scope :recent, lambda {{ :order => "comments.created_at DESC" } }
end
