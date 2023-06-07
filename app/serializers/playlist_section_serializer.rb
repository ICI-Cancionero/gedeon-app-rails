# == Schema Information
#
# Table name: playlist_sections
#
#  id          :bigint           not null, primary key
#  name        :string           default("")
#  playlist_id :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class PlaylistSectionSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :playlist_items, each_serializer: PlaylistItemSerializer
end
