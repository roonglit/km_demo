json.extract! message, :id, :create, :created_at, :updated_at
json.url message_url(message, format: :json)
