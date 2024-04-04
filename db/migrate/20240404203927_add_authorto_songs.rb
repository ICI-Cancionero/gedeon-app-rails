class AddAuthortoSongs < ActiveRecord::Migration[7.0]
  def change
    add_column :songs, :author, :string
  end
end
