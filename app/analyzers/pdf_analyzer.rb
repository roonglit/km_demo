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
      
      if result.empty?
        # we need to send the document to the OCR service here to save time downloading the file.
        Rails.logger.info "Send document to OCR service"
        client = TesseractClient.new(ENV['TESSERACT_SERVICE_URL'])
        callback_url = Rails.application.routes.url_helpers.pdf_callback_active_storage_blob_url(blob)
        client.extract_text(file.path, callback_url)
        return { require_ocr: true }
      end

      { text: result }
    end
  end
end
