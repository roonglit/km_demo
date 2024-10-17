# frozen_string_literal: true

class PdfAnalyzer < ActiveStorage::Analyzer
  def self.accept?(blob)
    blob.content_type == "application/pdf"
  end

  def metadata
    download_blob_to_tempfile do |file|
      result = pdf_reader(file.path)
      
      if result.empty?
        # we need to send the document to the OCR service here to save time downloading the file.
        Rails.logger.info "Send document to OCR service"
        client = TesseractClient.new(ENV['TESSERACT_SERVICE_URL'])

        callback_url = Rails.application.routes.url_helpers.pdf_callback_active_storage_blob_url(blob, host: ENV["KM_CALLBACK_HOST"])
        client.extract_text(file.path, callback_url)
        return { require_ocr: true }
      end

      { text: result }
    end
  end

  def pdf_reader(file_path)
    reader = PDF::Reader.new(file_path)
    result = reader.pages.map(&:text).join.gsub("\n", "")
  end

  def pdftotext(file_path)
    pages = Pdftotext.pages(file_path, enc: 'UTF-8')
    pages.map(&:text).join.gsub("\n", "")
  end
end
