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
class SongSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :position
  attributes :created_at, :updated_at
end
