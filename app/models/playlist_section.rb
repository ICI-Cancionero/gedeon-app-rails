class PlaylistSection < ApplicationRecord
  has_many :playlist_items, dependent: :destroy
  has_many :songs, through: :playlist_items

  accepts_nested_attributes_for :playlist_items, reject_if: :all_blank, allow_destroy: true
end
