class PlaylistSectionSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :playlist_items, each_serializer: PlaylistItemSerializer
end