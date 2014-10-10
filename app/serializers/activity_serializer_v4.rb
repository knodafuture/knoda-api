class ActivitySerializerV4 < ActiveModel::Serializer

  attributes :id, :user_id, :activity_type, :target, :title, :body, :created_at, :seen, :image_url, :shareable

  self.root = false

  def target
    if object.activity_type == 'INVITATION'
      return object.invitation_code
    elsif object.activity_type == 'FOLLOWING'
      return object.target_user_id
    else
      return object.prediction_id
    end
  end

  def title
    if object.activity_type == 'INVITATION'
      return "Hey-O! #{object.invitation_sender} has invited you to join a group"
    elsif object.activity_type == 'WON'
      title = object.title
      title.gsub!("You Won - ", "")
      return "#{title}"
    elsif object.activity_type == 'LOST'
      title = object.title
      title.gsub!("You Lost - ", "")
      return "#{title}"
    else
      return "#{object.title}"
    end
  end

  def body
    if object.activity_type == 'COMMENT'
      return object.comment_body
    elsif object.activity_type == 'INVITATION'
      return "Join \"#{object.invitation_group_name}\""
    elsif object.activity_type == 'FOLLOWING'
      return object.comment_body
    elsif object.activity_type == 'COMMENT_MENTION'
        return object.comment_body
    else
      return object.prediction_body
    end
  end
end
