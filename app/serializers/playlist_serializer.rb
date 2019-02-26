class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :playlist_sections, each_serializer: PlaylistSectionSerializer
  attributes :created_at, :updated_at
end