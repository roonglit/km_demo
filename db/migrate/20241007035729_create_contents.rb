class CreateContents < ActiveRecord::Migration[7.2]
  def change
    create_table :contents do |t|
      t.string :title
      t.text :body
      t.text :search_data
      t.integer :status
      t.references :contentable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
