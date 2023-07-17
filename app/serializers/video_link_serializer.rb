# == Schema Information
#
# Table name: video_links
#
#  id         :bigint           not null, primary key
#  provider   :integer          default("youtube"), not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  video_id   :string
#
class VideoLinkSerializer < ActiveModel::Serializer
  attributes :id, :provider, :video_id, :url
end
