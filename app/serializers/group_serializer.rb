class GroupSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :share_url, :avatar_image, :owner, :member_count, :leader_info, :my_info, :my_membership

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

  def owner
    return object.memberships.where(:role => 'OWNER').first.user_id
  end

  def my_membership
    return object.memberships.where(:user => current_user).first
  end
  
  self.root = false
end