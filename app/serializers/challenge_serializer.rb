class ChallengeSerializer < ActiveModel::Serializer

  attributes :id, :agree, :created_at, :is_own
  
  has_one :user
  has_one :prediction

  self.root = false
end