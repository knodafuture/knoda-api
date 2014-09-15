class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :phone, :created_at, :avatar_image, :verified_account
  attributes :points, :won, :lost, :winning_percentage
  attributes :streak, :social_accounts, :total_predictions, :guest_mode
  attributes :follower_count, :following_count, :following_id
  attributes :rivalry
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

  def include_rivalry?
    object.id != current_user.id
  end

  def include_social_accounts?
    object.id == current_user.id
  end

  def following_id
    if current_user.led_by?(object)
      return object.following(current_user).id
    else
      return nil
    end
  end

  def include_phone?
    object.id == current_user.id
  end

  def rivalry
    if object.rivalry
      puts "RIVALRY: REUSE"
      return object.rivalry
    else
      puts "RIVALRY: CREATE"
      return object.vs(current_user)
    end
  end
end
