json.extract! content, :id, :title, :body, :content_type, :status, :created_at, :updated_at
json.url content_url(content, format: :json)
