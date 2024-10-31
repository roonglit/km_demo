class AddRoleToMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :messages, :role, :string
  end
end
