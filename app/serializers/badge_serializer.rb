class BadgeSerializer < ActiveModel::Serializer

  attributes :id, :name, :created_at
  
  self.root = false
end