# == Schema Information
#
# Table name: playlists
#
#  id         :bigint           not null, primary key
#  name       :string
#  active     :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :playlist_sections, each_serializer: PlaylistSectionSerializer
  attributes :created_at, :updated_at
end
