module Langchain::Tool
  class Knowledge
    extend Langchain::ToolDefinition
    include Rails.application.routes.url_helpers

    define_function :get_knowledge, description: "return relevent knowledge from the query, including source of the knowledge" do 
      property :query,
        type: "string",
        description: "The query to search for",
        required: true
    end

    def get_knowledge(query:)
      content = Content.search(query).first
      { content: content.search_data, link: content_url(content) }
    end
  end
end