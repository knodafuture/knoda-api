class ChallengeHistorySerializer < ActiveModel::Serializer
  self.root = false
  
  attributes :id, :user_id, :agree
  attributes :username
  
  def username
    object.user.username
  end
end