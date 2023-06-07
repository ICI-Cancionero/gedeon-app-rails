# == Schema Information
#
# Table name: playlist_items
#
#  id                  :bigint           not null, primary key
#  position            :integer
#  song_id             :bigint
#  playlist_section_id :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class PlaylistItem < ApplicationRecord
  belongs_to :playlist_section, optional: true
  belongs_to :song, optional: true

  default_scope { order(position: :asc) }
end
