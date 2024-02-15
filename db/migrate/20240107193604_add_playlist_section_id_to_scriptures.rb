class AddPlaylistSectionIdToScriptures < ActiveRecord::Migration[7.0]
  def change
    add_reference :scriptures, :playlist_section
  end
end
