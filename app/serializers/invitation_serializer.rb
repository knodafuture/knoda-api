class InvitationSerializer < ActiveModel::Serializer

  attributes :id, :invitation_link
  has_one :group
  
  self.root = false
end