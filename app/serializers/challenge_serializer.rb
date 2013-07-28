class ChallengeSerializer < ActiveModel::Serializer

  attributes :id, :agree, :created_at, :is_own
  attributes :points
  
  has_one :user
  has_one :prediction
  

  self.root = false
  
  def points
    {
      base_points: object.base_points,
      outcome_points: object.outcome_points,
      market_size_points: object.market_size_points,
      prediction_market_points: object.prediction_market_points
    }
  end
end