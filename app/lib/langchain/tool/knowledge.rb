module Langchain::Tool
  class Knowledge
    extend Langchain::ToolDefinition

    define_function :get_knowledge, description: "return relevent chunks of text related to the query" do 
      property :query,
        type: "string",
        description: "The query to search for",
        required: true
    end

    def get_knowledge(query:)
      content = Content.search(query).first
      content.search_data
    end
  end
end