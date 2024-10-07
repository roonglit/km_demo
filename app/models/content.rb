class Content < ApplicationRecord
  include Chunkable

  enum status: { draft: 0, published: 1 }
  enum content_type: { article: 0, video: 1, audio: 2 }

  has_many :chunks, dependent: :destroy

  def chunkable_string
    body
  end

  def chunkable_separators
    ["\n"]
  end
end
