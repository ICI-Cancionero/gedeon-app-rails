# == Schema Information
#
# Table name: playlist_items
#
#  id                  :bigint           not null, primary key
#  position            :integer
#  song_id             :bigint
#  playlist_section_id :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class PlaylistItemSerializer < ActiveModel::Serializer
  attributes :id, :position, :song
end
