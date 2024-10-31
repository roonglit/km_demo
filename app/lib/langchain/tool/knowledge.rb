module Langchain::Tool
  class Knowledge
    extend Langchain::ToolDefinition
    include Rails.application.routes.url_helpers

    define_function :get_knowledge, description: "return array of relevent knowledge from the query, including source of the knowledge" do 
      property :query,
        type: "string",
        description: "The query to search for",
        required: true
    end

    def initialize(llm)
      @llm = llm
    end

    def get_knowledge(query:)
      query_embedding = @llm.embed(text: :query).embedding
      Chunk
        .nearest_neighbors(:embedding, query_embedding, distance: "cosine")
        .includes(:content)
        .first(3)
        .map {|c| {text: c.text, url: content_path(c.content)} }
    end
  end
end