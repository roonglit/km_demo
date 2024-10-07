class Chunk < ApplicationRecord
  belongs_to :content
  has_neighbors :embedding
end
