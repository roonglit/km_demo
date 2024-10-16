class Article < ApplicationRecord
  include AnalyzerLifeCycle

  has_many_attached :files
  has_one :content, as: :contentable, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :content

  delegate :title, :body, :search_data, to: :content

  after_file_analyzed :update_search_data

  def update_search_data(metadata)
    if metadata[:text]
      self.content.search_data = self.content.reload.search_data + metadata[:text]
    end
    self.content.save!

    self.increment!(:files_analyzed_count)

    if self.files_analyzed_count == self.files.size
      Rails.logger.info "All files analyzed for article #{self.id}"
      self.content.create_chunks
      self.update!(files_analyzed_count: 0)
    else
      Rails.logger.info "Files analyzed count for article #{self.id} is #{self.files_analyzed_count}"
    end
  end
end
