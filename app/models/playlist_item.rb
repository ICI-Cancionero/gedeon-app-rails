class PlaylistItem < ApplicationRecord
  belongs_to :playlist_section, optional: true
  belongs_to :song, optional: true

  default_scope { order(position: :asc) }
end
