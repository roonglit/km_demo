require 'httparty'

class TesseractClient
  include HTTParty
  base_uri 'http://localhost:5000'

  def initialize(url)
    self.class.base_uri url
  end

  def extract_text(file_path)
    options = {
      headers: { 'Content-Type' => 'multipart/form-data' },
      body: { pdf: File.open(file_path) }
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