class PredictionFeedSerializer < PredictionSerializer
  self.root = false
  
  attributes :my_challenge
  attributes :my_points
  
  def my_challenge
    current_user.challenges.where(prediction_id: object.id).first
  end
  
  def my_points
    if self.my_challenge
      self.my_challenge.points_details
    end
  end
end
