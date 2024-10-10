class AddContentableToContents < ActiveRecord::Migration[7.2]
  def change
    add_reference :contents, :contentable, polymorphic: true, null: false
  end
end
