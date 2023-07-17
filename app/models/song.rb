# == Schema Information
#
# Table name: songs
#
#  id         :bigint           not null, primary key
#  title      :string
#  content    :text
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Song < ApplicationRecord
  has_and_belongs_to_many :playlists
  has_and_belongs_to_many :video_links

  accepts_nested_attributes_for :video_links, reject_if: :all_blank, allow_destroy: true
end
