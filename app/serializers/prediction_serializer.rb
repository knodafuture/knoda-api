class PredictionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :text, :expires_at, :closed, :closed_at, :closed_as
end
