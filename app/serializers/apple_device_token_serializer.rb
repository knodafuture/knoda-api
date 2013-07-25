class AppleDeviceTokenSerializer < ActiveModel::Serializer

  attributes :id, :token, :created_at
  
  self.root = false
end