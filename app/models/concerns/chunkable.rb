module Chunkable
  extend ActiveSupport::Concern

  included do
    delegate :open_ai, to: :class
  end

  class_methods do
    def search(q, distance_threshold: 0.5)
      query_embedding = open_ai.embed(text: q).embedding
      Chunk
        .nearest_neighbors(:embedding, query_embedding, distance: "cosine")
        .includes(:content)
        .first(30)
        .map(&:content)
        .uniq
        .first(10)
    end

    def open_ai
      Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
    end
  end

  def create_chunks
    chunks.destroy_all
    generate_chunks.each do |chunk|
      chunks.create!(chunk)
    end
    log_chunk_creation
  end

  private

  def generate_chunks
    Langchain::Chunker::RecursiveText.new(
      chunkable_string,
      chunk_size: 1536,
      chunk_overlap: 200,
      separators: chunkable_separators
    ).chunks.map do |chunk|
      {
        text: chunk.text,
        embedding: open_ai.embed(text: chunk.text).embedding
      }
    end
  end

  def log_chunk_creation
    puts "#{chunks.count} chunks created for #{self.class.name} #{id}"
  end
end