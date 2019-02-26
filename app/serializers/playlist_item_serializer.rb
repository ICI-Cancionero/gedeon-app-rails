class PlaylistItemSerializer < ActiveModel::Serializer
  attributes :id, :position, :song
end