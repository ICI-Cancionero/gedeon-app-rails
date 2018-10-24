class Playlist < ApplicationRecord
  has_and_belongs_to_many :songs

  def song_titles
    self.songs.pluck(:title)
  end
end
