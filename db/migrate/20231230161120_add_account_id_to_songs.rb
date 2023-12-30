class AddAccountIdToSongs < ActiveRecord::Migration[7.0]
  def change
    add_reference :songs, :account, index: true, foreign_key: true
  end
end
