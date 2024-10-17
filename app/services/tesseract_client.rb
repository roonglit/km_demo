require 'httparty'

class TesseractClient
  include HTTParty
  base_uri 'http://localhost:5000'

  def initialize(url)
    Rails.logger.info "TesseractClient initialized with url: #{url}"
    self.class.base_uri url
  end

  def extract_text(file_path, callback_url)
    Rails.logger.info "Extracting text from file: #{file_path} and calling back to: #{callback_url}"
    options = {
      headers: { 'Content-Type' => 'multipart/form-data' },
      body: { pdf: File.open(file_path), callback_url: callback_url }
    }
    response = self.class.post('/extract_text', options)
    handle_response(response)
  end

  private

  def handle_response(response)
    if response.success?
      response.body
    else
      raise "Failed to extract text: #{response.body}"
    end
  end
end