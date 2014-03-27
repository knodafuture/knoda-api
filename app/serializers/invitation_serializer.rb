class InvitationSerializer < ActiveModel::Serializer

  attributes :id, :group_id, :invitation_link, :group_name, :group_description, :owner_username
  
  self.root = false

  def group_name
    object.group.name
  end

  def group_description
    object.group.description
  end

  def owner_username
    object.user.username
  end

end