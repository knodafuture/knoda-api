class ContestSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :detail_url, :created_at, :avatar_image, :contest_stages, :leader_info, :my_info, :participants
  self.root = false

  def my_info
    l = Contest.leaderboard(object)
    if l.size > 0 and l[0][:won] > 0
      me = l.select { |u| u[:user_id] == current_user.id}
      if me.length > 0
        return {:rank => me[0][:rank]}
      else
        return nil;
      end
    else
      return nil;
    end
  end
end
