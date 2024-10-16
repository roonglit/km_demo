class AddFilesCountToArticles < ActiveRecord::Migration[7.2]
  def change
    add_column :articles, :files_analyzed_count, :integer, default: 0
  end
end
