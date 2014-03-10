class GroupSerializer < ActiveModel::Serializer

  attributes :id, :name, :description
  
  self.root = false

end