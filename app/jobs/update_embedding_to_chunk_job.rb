class UpdateEmbeddingToChunkJob < ApplicationJob
  queue_as :default

  def perform(chunk_id)
    # Do something later
    chunk = Chunk.find(chunk_id)
    embedding = open_ai.embed(text: chunk.text).embedding
    chunk.update!(embedding: embedding)
  end

  def open_ai
    Langchain::LLM::OpenAI.new(api_key: ENV["OPENAI_API_KEY"])
  end
end
