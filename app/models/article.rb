class Article < ApplicationRecord
  has_one :content, as: :contentable, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :content

  delegate :title, :body, to: :content
end
