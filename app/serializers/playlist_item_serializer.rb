# == Schema Information
#
# Table name: playlist_items
#
#  id                  :bigint           not null, primary key
#  position            :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  playlist_section_id :bigint
#  song_id             :bigint
#
# Indexes
#
#  index_playlist_items_on_playlist_section_id  (playlist_section_id)
#  index_playlist_items_on_song_id              (song_id)
#
class PlaylistItemSerializer < ActiveModel::Serializer
  attributes :id, :position, :song
end
