class InvitationSerializer < ActiveModel::Serializer

  attributes :id, :group_id, :invitation_link
  
  self.root = false

end