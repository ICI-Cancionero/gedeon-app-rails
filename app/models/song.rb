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
end
