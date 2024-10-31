class GetAnswerJob < ApplicationJob
  queue_as :default

  def perform(chat_id)
    llm = Langchain::LLM::OpenAI.new(api_key: ENV['OPENAI_API_KEY'])
    assistant = Langchain::Assistant.new(
      llm: llm,
      instructions: "You have knowledge from our database. Use it to help the user.",
      tools: [Langchain::Tool::Knowledge.new]
    )

    # load history from chat
    messages = Message.where(chat_id: chat_id).order(:created_at)
    messages.each do |m|
      assistant.add_message(role: m.role, content: m.content)
    end

    messages = assistant.run!
    answer = messages.filter { |m| m.role == "assistant" }.last

    message = Message.create(
      chat_id: chat_id,
      content: answer.content,
      role: "assistant"
    )

    message.broadcast_append_to(
      message.chat, 
      partial: "messages/message", 
      locals: { message: message }, 
      target: "messages"
    )
  end
end
