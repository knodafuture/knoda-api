class ActivitySerializerV4 < ActiveModel::Serializer

  attributes :id, :user_id, :activity_type, :target, :text, :title, :body, :created_at, :seen, :image_url

  self.root = false

  def target
    if object.activity_type == 'INVITATION'
      return object.invitation_code
    else
      return object.prediction_id
    end
  end

  def text
    if object.activity_type == 'INVITATION'
      return "#{object.invitation_sender} has invited you to join the group \"#{object.invitation_group_name}\""
    elsif object.activity_type == 'COMMENT' and object.comment_body
      return "#{object.title} <span class='comment_body'>\"#{object.comment_body}\"</span>"
    elsif object.activity_type == 'WON'
      title = object.title
      title.gsub!("You Won", "<span class='won_text'>You Won</span>")
      return "#{title} \"#{object.prediction_body}\""
    elsif object.activity_type == 'LOST'
      title = object.title
      title.gsub!("You Lost", "<span class='lost_text'>You Lost</span>")
      return "#{object.title} \"#{object.prediction_body}\""
    else
      return "#{object.title} \"#{object.prediction_body}\""
    end
  end

  def title
    if object.activity_type == 'INVITATION'
      return "Hey-O! #{object.invitation_sender} has invited you to join a group"
    elsif object.activity_type == 'WON'
      title = object.title
      title.gsub!("You Won", "<span class='won_text'>You Won</span>")
      return "#{title}"
    elsif object.activity_type == 'LOST'
      title = object.title
      title.gsub!("You Lost", "<span class='lost_text'>You Lost</span>")
      return "#{object.title}"
    else
      return "#{object.title}"
    end
  end

  def body
    if object.activity_type == 'COMMENT'
      return object.comment_body
    elsif object.activity_type == 'INVITATION'
      return "Join \"#{object.invitation_group_name}\""
    else
      return object.prediction_body
    end
  end
end
