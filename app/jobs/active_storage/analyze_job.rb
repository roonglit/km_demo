# flozen_string_literal: true

class ActiveStorage::AnalyzeJob < ActiveStorage::BaseJob
  def perform(blob)
    blob.analyze

    return if blob.metadata[:require_ocr]

    blob.attachments.includes(:record).each do |attachment|
      record = attachment.record
      if record.respond_to?(:run_file_analyzed_callbacks)
        record.run_file_analyzed_callbacks(blob.metadata)
      end
    end
  end
end