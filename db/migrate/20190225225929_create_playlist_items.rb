class CreatePlaylistItems < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_items do |t|
      t.integer :position
      t.references :song
      t.references :playlist_section
      t.timestamps
    end
  end
end
