# frozen_string_literal: true

class PdfAnalyzer < ActiveStorage::Analyzer
  def self.accept?(blob)
    blob.content_type == "application/pdf"
  end

  def metadata
    download_blob_to_tempfile do |file|
      reader = PDF::Reader.new(file.path)
      # if result contains no text or only \n characters, it's probably a scanned document
      result = reader.pages.map(&:text).join.gsub("\n", "")
      # we will send scaned document to tesseract service
      if result.empty?
        Rails.logger.info "Scanned document detected"
        client = TesseractClient.new(ENV['TESSERACT_SERVICE_URL'])
        result = client.extract_text(file.path)
      end

      { text: result }
    end
  end
end
