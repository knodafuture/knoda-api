class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar, :notifications, :points, :won, :lost, :streak, :streak_s

  self.root = false
end
