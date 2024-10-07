# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

contents = [
  {
    title: "The Impact of Climate Change on Arctic Ice",
    status: :published,
    content_type: :article,
    body: "Climate change is accelerating the melting of ice in the Arctic, leading to rising sea levels worldwide. This significant environmental shift impacts biodiversity and increases flood risks."
  },
  {
    title: "Mastering Steak Cooking",
    status: :published,
    content_type: :video,
    body: "Learn how to cook the perfect steak, with tips on choosing the right cuts, seasoning, and cooking techniques to enhance flavor and ensure juiciness."
  },
  {
    title: "AI in Healthcare",
    status: :published,
    content_type: :audio,
    body: "The future of artificial intelligence in healthcare is promising, with AI applications ranging from diagnostic support to personalized medicine and patient management."
  },
  {
    title: "Modern Web Development Trends",
    status: :draft,
    content_type: :article,
    body: "Modern web development trends are leaning towards more interactive and dynamic user experiences, utilizing technologies like React, Vue, and Angular for front-end development."
  },
  {
    title: "Financial Literacy 101",
    status: :published,
    content_type: :article,
    body: "Financial literacy is key to personal financial success. Understanding basics of budgeting, investing, and debt management can significantly improve your financial stability."
  },
  {
    title: "The History of Jazz in America",
    status: :published,
    content_type: :video,
    body: "This documentary explores the history and cultural impact of jazz music in America, featuring performances and interviews with renowned artists."
  },
  {
    title: "Privacy vs. Security Debate",
    status: :published,
    content_type: :audio,
    body: "The debate on data privacy versus security is ongoing, with experts discussing the balance between protecting citizens' personal information and ensuring national security."
  }
]

contents.each do |content_params|
  Content.find_or_create_by(title: content_params[:title]) do |content|
    content.status = content_params[:status]
    content.content_type = content_params[:content_type]
    content.body = content_params[:body]
  end
end

puts 'Database seeded with diverse content for semantic search testing.'
