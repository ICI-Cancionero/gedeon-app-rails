class Playlist < ApplicationRecord
  has_many :playlist_sections, dependent: :destroy
  has_many :playlist_items, through: :playlist_sections
  has_many :songs, through: :playlist_items

  scope :active, -> { where(active: true) }

  accepts_nested_attributes_for :playlist_sections, reject_if: :all_blank, allow_destroy: true

  def song_titles
    self.songs.pluck(:title)
  end
end
