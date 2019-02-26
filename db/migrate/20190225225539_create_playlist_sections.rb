class CreatePlaylistSections < ActiveRecord::Migration[5.2]
  def change
    create_table :playlist_sections do |t|
      t.string :name, default: ''
      t.references :playlist
      t.timestamps
    end
  end
end
