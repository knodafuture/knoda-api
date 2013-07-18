class PredictionAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    true
  end
  
  def self.readable_by?(user)
    true
  end
  
  def updatable_by?(user)
    user.id == resource.user_id
  end
  
  def deletable_by?(user)
    user.id == resource.user_id
  end
  
  def agreeable_by?(user)
    user.id != resource.user_id
  end
  
  def disagreeable_by?(user)
    user.id != resource.user_id
  end
  
  def realizable_by?(user)
    user.id == resource.user_id
  end
  
  def unrealizable_by?(user)
    user.id == resource.user_id
  end
end