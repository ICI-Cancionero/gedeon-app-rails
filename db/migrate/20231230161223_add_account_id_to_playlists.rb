class AddAccountIdToPlaylists < ActiveRecord::Migration[7.0]
  def change
    #add_column :playlists, :account_id, :integer
    #add_index :playlists, :account_id
    add_reference :playlists, :account, index: true, foreign_key: true
  end
end
