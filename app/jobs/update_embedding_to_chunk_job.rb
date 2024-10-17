class UpdateEmbeddingToChunkJob < ApplicationJob
  queue_as :default

  def perform(chunk_id)
    # Do something later
    chunk = Chunk.find(chunk_id)
    embedding = open_ai.embed(text: chunk.text).embedding
    chunk.update!(embedding: embedding)
  end

  def open_ai
    Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      default_options: { temperature: 0.7, chat_completion_model_name: "gpt-4o" }
    )
  end
end
