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
    0
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
      return object.rivalry
    else
      return object.vs(current_user)
    end
  end
end
