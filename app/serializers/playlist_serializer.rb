# == Schema Information
#
# Table name: playlists
#
#  id         :bigint           not null, primary key
#  active     :boolean
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint
#
# Indexes
#
#  index_playlists_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class PlaylistSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :playlist_sections, each_serializer: PlaylistSectionSerializer
  attributes :created_at, :updated_at
end
