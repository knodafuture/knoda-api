class ActivitySerializerV4 < ActiveModel::Serializer

  attributes :id, :user_id, :activity_type, :target, :text, :created_at, :seen

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
      return "<p><b>#{object.invitation_sender} has invited you to join the group</b> \"#{object.invitation_group_name}\"</p>"
    elsif object.activity_type == 'COMMENT' and object.comment_body
      return "<p><b>#{object.title}</b> <span class='comment_body'>\"#{object.comment_body}\"</span></p>"
    elsif object.activity_type == 'WON'
      title = object.title
      title.gsub!("You Won", "<span class='won_text'>You Won</span>")
      return "<p><b>#{title}</b> \"#{object.prediction_body}\"</p>"
    elsif object.activity_type == 'LOST'
      title = object.title
      title.gsub!("You Lost", "<span class='lost_text'>You Lost</span>")      
      return "<p><b>#{object.title}</b> \"#{object.prediction_body}\"</p>"
    else
      return "<p><b>#{object.title}</b> \"#{object.prediction_body}\"</p>"
    end
  end
end
