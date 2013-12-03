class Comment < ActiveRecord::Base
  belongs_to :user, inverse_of: :comments
  belongs_to :prediction, inverse_of: :comments

  validates :user_id, presence: true
  validates :prediction_id, presence: true
  
  include Authority::Abilities
  self.authorizer_name = 'CommentAuthorizer'

  scope :recent, lambda {{ :order => "comments.created_at DESC" } }
end
