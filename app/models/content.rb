class Content < ApplicationRecord
  include Chunkable

  enum status: [:draft, :published]
  enum content_type: [:article, :video, :audio]

  belongs_to :contentable, polymorphic: true
  has_many :chunks, dependent: :destroy

  def chunkable_string
    body
  end

  def chunkable_separators
    ["\n"]
  end
end
