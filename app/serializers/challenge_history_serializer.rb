class ChallengeHistorySerializer < ActiveModel::Serializer
  self.root = false
  
  attributes :user_id, :agree
  attributes :username
  attributes :verified_account
  
  def username
    object.user.username
  end
  def verified_account
  	object.user.verified_account
  end
end