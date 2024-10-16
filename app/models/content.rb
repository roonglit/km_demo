class Content < ApplicationRecord
  include Chunkable

  enum status: [:draft, :published]

  belongs_to :contentable, polymorphic: true
  has_many :chunks, dependent: :destroy

  def chunkable_string
    search_data
  end

  def chunkable_separators
    ["\n"]
  end
end
