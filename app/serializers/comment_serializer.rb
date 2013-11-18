class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :created_at
  attributes :user_id, :username, :user_avatar
  attributes :challenge
  
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

  def agreed
    [true, false].sample
  end
  
end
