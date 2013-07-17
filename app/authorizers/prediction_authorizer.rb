class PredictionAuthorizer < ApplicationAuthorizer
  def self.creatable_by?(user)
    true
  end
  
  def self.readable_by?(user)
    true
  end
  
  def self.updatable_by?(user)
    true
  end
  
  def self.deletable_by?(user)
    true
  end
  
  def self.agreeable_by?(user)
    true
  end
  
  def self.disagreeable_by?(user)
    true
  end
end