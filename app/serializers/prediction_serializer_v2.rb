class PredictionSerializerV2 < ActiveModel::Serializer
  attributes :id , :body, :outcome, :expires_at, :created_at, :closed_at, :short_url, :resolution_date
  attributes :agreed_count, :disagreed_count, :comment_count
  attributes :user_id, :username, :user_avatar
  attributes :expired, :settled, :is_ready_for_resolution
  attributes :verified_account
  attributes :tags
  attributes :group_id, :group_name
  attributes :shareable_image
  attributes :expired_text, :predicted_text
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

  def is_ready_for_resolution
    object.resolution_date != nil && object.resolution_date.past?
  end

  def verified_account
    object.user.verified_account
  end

  def group_id
    return object.group_id
  end

  def group_name
    if object.group != nil
      object.group.name
    else
      return nil
    end
  end
end
