class UserH2hSerializer < UserSerializer
  def include_follower_count?
    false
  end

  def include_following_count?
    false
  end

  def include_following_id?
    false
  end
end
