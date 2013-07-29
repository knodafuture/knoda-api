class PredictionFeedSerializer < PredictionSerializer
  self.root = false
  
  attributes :my_challenge
  
  def my_challenge
    current_user.challenges.where(prediction_id: object.id)
  end
end
