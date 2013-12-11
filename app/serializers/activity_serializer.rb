class ActivitySerializer < ActiveModel::Serializer

  attributes :id, :prediction_id, :activity_type, :user_id, :prediction_body, :title, :created_at, :seen
  
  self.root = false

end