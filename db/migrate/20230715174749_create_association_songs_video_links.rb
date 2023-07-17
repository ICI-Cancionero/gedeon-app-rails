class CreateAssociationSongsVideoLinks < ActiveRecord::Migration[7.0]
  def change
    create_join_table :songs, :video_links do |t|
      t.index :song_id
      t.index :video_link_id
    end
  end
end
