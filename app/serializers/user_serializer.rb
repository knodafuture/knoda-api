class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar, :notifications, :points

  self.root = false
end
