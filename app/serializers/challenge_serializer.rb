class ChallengeSerializer < ActiveModel::Serializer

  attributes :id, :agree, :created_at
  
  has_one :user
  has_one :prediction

  self.root = false
end