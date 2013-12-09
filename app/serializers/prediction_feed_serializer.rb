class PredictionFeedSerializer < PredictionSerializer
  self.root = false
  
  attributes :my_challenge
  attributes :my_points
  attributes :resolution_date
  
  def my_challenge
    l = object.challenges.select { |c| c.user_id == current_user.id}
    if l.length > 0
      return l[0]
    else
      return nil
    end
  end
  
  def my_points
    if self.my_challenge
      self.my_challenge.points_details
    end
  end
end
