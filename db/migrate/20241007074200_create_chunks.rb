class CreateChunks < ActiveRecord::Migration[7.2]
  def change
    create_table :chunks do |t|
      t.belongs_to :content, null: false, foreign_key: true
      t.text :text
      t.vector :embedding, limit: 1536

      t.timestamps
    end
  end
end
