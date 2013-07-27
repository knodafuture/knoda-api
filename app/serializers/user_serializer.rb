class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar_image, :notifications
  attributes :points, :won, :lost, :winning_percentage
  attributes :streak, :streak_string
  attributes :total_predictions
  attributes :alerts

  self.root = false
  
  def streak_string
    if object.streak == 0
      return ""
    end
    
    if object.streak > 0
      return "W#{self.streak}"
    end
    
    if object.streak < 0
      return "L#{self.streak}"
    end
  end
  
  def total_predictions
    object.predictions.count
  end
  
  def alerts
    object.alerts_count
  end
end
