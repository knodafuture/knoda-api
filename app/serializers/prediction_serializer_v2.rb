class PredictionSerializerV2 < ActiveModel::Serializer
  attributes :id , :body, :outcome, :expires_at, :created_at, :closed_at, :short_url, :resolution_date
  attributes :agreed_count, :disagreed_count, :comment_count
  attributes :user_id, :username, :user_avatar
  attributes :expired, :settled, :is_ready_for_resolution
  attributes :verified_account
  attributes :tags
  attributes :group_id, :group_name
  attributes :contest_id, :contest_name
  attributes :shareable_image
  attributes :expired_text, :predicted_text
  attributes :embed_locations
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

  def contest_id
    return object.contest_id
  end

  def embed_locations
    locations = object.embed_locations.collect { |el| {:url => el.url, :domain => el.domain } }
    blacklist = ['translate.googleusercontent.com', nil]
    locations.reject { |el| blacklist.include? el[:domain]}
  end
end
