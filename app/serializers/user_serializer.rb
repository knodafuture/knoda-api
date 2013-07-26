class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar_image, :notifications, :points, :won, :lost, :streak, :streak_s, :winning_percentage

  self.root = false
end
