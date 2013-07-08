json.array!(@predictions) do |prediction|
  json.extract! prediction, :user_id, :text, :expires_at, :closed, :closed_at, :closed_as
  json.url prediction_url(prediction, format: :json)
end
