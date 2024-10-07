class Content < ApplicationRecord
  enum status: { draft: 0, published: 1 }
  enum content_type: { article: 0, video: 1, audio: 2 }
end
