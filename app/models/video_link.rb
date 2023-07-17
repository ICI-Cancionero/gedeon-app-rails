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
class VideoLink < ApplicationRecord
  enum :provider, { youtube: 0, vimeo: 1 }, prefix: true

  has_and_belongs_to_many :songs

  validates :provider, presence: true

  before_save :set_video_id

  private

  def set_video_id
    self.video_id = extract_youtube_video_id(self.url) if self.provider_youtube?
    self.video_id = extract_vimeo_video_id(self.url) if self.provider_vimeo?
  end

  def extract_youtube_video_id(url)
    # Regular expression pattern to match YouTube video URLs
    pattern = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
    # Match the video ID in the URL
    match = pattern.match(self.url)

    if match && match[1]
      return match[1]
    end
  end

  def extract_vimeo_video_id(url)
    # Regular expression pattern to match Vimeo video URLs
    pattern = /vimeo.com\/(?:video\/)?(\d+)/
    # Match the video ID in the URL
    match = pattern.match(self.url)

    if match && match[1]
      return match[1]
    end
  end
end
