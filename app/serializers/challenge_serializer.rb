class ChallengeSerializer < ActiveModel::Serializer

  attributes :id, :agree, :created_at, :is_own
  attributes :points_details
  attributes :bs
  
  has_one :user
  has_one :prediction
  
  self.root = false

end