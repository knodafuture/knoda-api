class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar, :notifications

  self.root = false
end
