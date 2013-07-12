class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar

  self.root = false
end
