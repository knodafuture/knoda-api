class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar, :notifications, :points, :won, :lost, :streak, :streak_s, :winning_percentage

  self.root = false
end
