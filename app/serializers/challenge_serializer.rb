class ChallengeSerializer < ActiveModel::Serializer

  attributes :id, :is_positive

  has_one :user
  has_one :prediction

  self.root = false
end