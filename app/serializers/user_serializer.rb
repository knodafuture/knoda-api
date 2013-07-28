class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar_image, :notifications
  attributes :points, :won, :lost, :winning_percentage
  attributes :streak
  attributes :total_predictions
  attributes :alerts
  attributes :badges

  self.root = false
  
  def streak
    if object.streak == 0
      return ""
    end
    
    if object.streak > 0
      return "W#{object.streak}"
    end
    
    if object.streak < 0
      return "L#{object.streak.abs}"
    end
  end
  
  def total_predictions
    object.predictions.count
  end
  
  def alerts
    object.alerts_count
  end
  
  def badges
    object.badges.unseen.count
  end
  
  def include_notifications?
    object.id == current_user.id
  end
  
  def include_alerts?
    object.id == current_user.id
  end
  
  def include_badges?
    object.id == current_user.id
  end
  
  def include_won?
    object.id == current_user.id
  end
  
  def include_lost?
    object.id == current_user.id
  end
  
  def include_winning_percentage?
    object.id == current_user.id
  end
  
  def include_streak?
    object.id == current_user.id
  end
end
