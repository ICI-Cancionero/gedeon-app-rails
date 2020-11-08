class Song < ApplicationRecord
  has_and_belongs_to_many :playlists
  has_one_attached :karaoke_track
  has_one_attached :acappella_track
  has_one_attached :backing_track
  has_one_attached :complete_track
end
