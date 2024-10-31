class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.text :content
      t.belongs_to :chat, null: false, foreign_key: true

      t.timestamps
    end
  end
end