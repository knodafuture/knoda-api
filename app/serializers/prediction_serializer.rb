class PredictionSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :body, :outcome, :expires_at, :created_at, :closed_at, :ratio

  has_many :tags

  self.root = false
end
