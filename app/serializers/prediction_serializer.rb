class PredictionSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :title, :text, :expires_at, :created_at

  has_many :tags

  self.root = false
end
