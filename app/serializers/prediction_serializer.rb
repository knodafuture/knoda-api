class PredictionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :body, :outcome, :expires_at, :created_at, :closed_at
  attributes :agreed_count, :disagreed_count
  attributes :market_size, :prediction_market
  
  attributes :username, :user_avatar
  
  has_many :tags

  self.root = false
  
  def username
    object.user.username
  end
  
  def user_avatar
    object.user.avatar_image
  end
end
