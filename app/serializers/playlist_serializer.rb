class PlaylistSerializer < ActiveModel::Serializer
    attributes :id, :name, :songs
    attributes :created_at, :updated_at
end