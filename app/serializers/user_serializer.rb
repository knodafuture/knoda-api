class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar, :notifications, :points, :won, :lost

  self.root = false
end
