class CreateContents < ActiveRecord::Migration[7.2]
  def change
    create_table :contents do |t|
      t.string :title
      t.text :body
      t.integer :content_type
      t.integer :status

      t.timestamps
    end
  end
end
