class MembershipSerializer < ActiveModel::Serializer

  attributes :id, :group_id, :user_id, :username, :role
  
  self.root = false
end