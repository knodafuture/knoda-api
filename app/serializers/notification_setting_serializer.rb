class NotificationSettingSerializer < ActiveModel::Serializer
  attributes :id, :setting, :display_name, :description, :active
  self.root = true
end
