class PlaylistItem < ApplicationRecord
  belongs_to :playlist_section
  belongs_to :song

  default_scope { order(position: :asc) }
end
