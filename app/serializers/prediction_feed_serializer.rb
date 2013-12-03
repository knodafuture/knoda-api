class PredictionFeedSerializer < PredictionSerializer
  self.root = false
  
  attributes :my_challenge
  attributes :my_points
  attributes :resolution_date
  
  def my_challenge
    #current_user.challenges.where(prediction_id: object.id).first
    l = current_user.challenges.select { |c| c.prediction_id == object.id}
    l.first    
  end
  
  def my_points
    if self.my_challenge
      self.my_challenge.points_details
    end
  end
end
