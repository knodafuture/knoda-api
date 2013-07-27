class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :created_at, :avatar_image, :notifications, :points, :won, :lost, :streak, :winning_percentage
  attributes :streak_string

  self.root = false
  
  def streak_string
    if self.streak == 0
      return ""
    end
    
    if self.streak > 0
      return "W#{self.streak}"
    end
    
    if self.streak < 0
      return "L#{self.streak}"
    end
  end
end
