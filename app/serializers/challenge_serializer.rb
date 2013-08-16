class ChallengeSerializer < ActiveModel::Serializer

  attributes :id, :agree, :created_at, :is_own, :is_right, :is_finished, :seen
  attributes :points_details
  attributes :bs
  
  has_one :user
  has_one :prediction
  
  self.root = false

end