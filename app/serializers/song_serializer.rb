class SongSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :position
  attributes :created_at, :updated_at
end