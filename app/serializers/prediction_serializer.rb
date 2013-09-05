class PredictionSerializer < ActiveModel::Serializer
  attributes :id, :body, :outcome, :expires_at, :created_at, :closed_at
  attributes :agreed_count, :disagreed_count
  attributes :market_size, :prediction_market
  
  attributes :user_id, :username, :user_avatar
  attributes :expired
  attributes :settled

  attributes :unfinished
  
  has_many :tags

  self.root = false
  
  def settled
    object.is_closed?
  end
  
  def expired
    object.expires_at && object.expires_at.past?
  end
  
  def username
    object.user.username
  end
  
  def user_avatar
    object.user.avatar_image
  end
end
