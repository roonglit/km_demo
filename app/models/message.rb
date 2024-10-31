class Message < ApplicationRecord
  validates :role, inclusion: { in: %w[system user assistant] }
  belongs_to :chat
end
