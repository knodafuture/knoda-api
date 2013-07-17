class ChallengeSerializer < ActiveModel::Serializer

  attributes :id, :agree
  
  has_one :user
  has_one :prediction

  self.root = false
end