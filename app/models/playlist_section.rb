class PlaylistSection < ApplicationRecord
  belongs_to :playlist, optional: true
  has_many :playlist_items, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :songs, -> { order(created_at: :asc) }, through: :playlist_items

  accepts_nested_attributes_for :playlist_items, reject_if: :all_blank, allow_destroy: true
end
