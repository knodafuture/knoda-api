class AppleDeviceTokenSerializer < ActiveModel::Serializer

  attributes :id, :token, :sandbox, :created_at
  
  self.root = false
end