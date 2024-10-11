class AddTokensToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :token, :text
    add_column :users, :refresh_token, :text
    add_column :users, :token_expires_at, :timestamp
  end
end
