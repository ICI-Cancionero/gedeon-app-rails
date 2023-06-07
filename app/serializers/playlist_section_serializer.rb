# == Schema Information
#
# Table name: playlist_sections
#
#  id          :bigint           not null, primary key
#  name        :string           default("")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  playlist_id :bigint
#
# Indexes
#
#  index_playlist_sections_on_playlist_id  (playlist_id)
#
class PlaylistSectionSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :playlist_items, each_serializer: PlaylistItemSerializer
end
