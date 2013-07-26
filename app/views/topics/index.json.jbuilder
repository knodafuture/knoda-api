json.array!(@topics) do |topic|
  json.extract! topic, :name
  json.url topic_url(topic, format: :json)
end
