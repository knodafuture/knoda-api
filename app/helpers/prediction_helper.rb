module PredictionHelper
  def my_challenge(prediction)
    l = prediction.challenges.select { |c| c.user_id == current_user.id}
    if l.length > 0
      return l[0]
    else
      return nil
    end
  end

  def my_points(prediction)
    if self.my_challenge(prediction)
      self.my_challenge(prediction).points_details
    end
  end    
end
