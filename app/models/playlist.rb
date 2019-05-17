class Playlist < ApplicationRecord
  has_many :playlist_sections, dependent: :destroy
  has_many :playlist_items, through: :playlist_sections
  has_many :songs, through: :playlist_items

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: [nil, false]) }

  accepts_nested_attributes_for :playlist_sections, reject_if: :all_blank, allow_destroy: true

  def song_titles
    self.songs.pluck(:title)
  end

  def duplicate
    new_playlist = self.dup
    self.playlist_sections.each do |section|
      new_section = section.dup
      new_playlist.playlist_sections << new_section
      section.playlist_items.each do |item|
        new_item = item.dup
        new_section.playlist_items << new_item
      end
    end
    new_playlist.save
    new_playlist
  end
end
