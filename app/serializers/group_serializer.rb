class GroupSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :avatar_image, :member_count, :leader_info, :my_info

  def member_count
    return object.memberships.size
  end

  def leader_info
    l = Group.weeklyLeaderboard(object)[0]
    return {:username => l[:username]}
  end

  def my_info
    me = Group.weeklyLeaderboard(object).select { |u| u[:user_id] == current_user.id}
    if me.length > 0
      return {:rank => me[0][:rank]}
    else
      return nil;
    end
  end
  
  self.root = false
end