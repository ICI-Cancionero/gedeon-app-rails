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
    self.video_id = extract_youtube_video_id(url) if provider_youtube?
    self.video_id = extract_vimeo_video_id(url) if provider_vimeo?
  end

  def extract_youtube_video_id(_url)
    pattern = %r{
      (?:
        youtube(?:-nocookie)?\.com/   # youtube.com or youtube-nocookie.com
        (?:
          [^/\n\s]+/\S+/             # channel/user paths
          |(?:v|e(?:mbed)?)/         # /v/ or /embed/
          |\S*?[?&]v=               # ?v= or &v= query param
        )
        |youtu\.be/                  # short URL
      )
      ([a-zA-Z0-9_-]{11})           # 11-char video ID
    }x

    url.match(pattern)&.captures&.first
  end

  def extract_vimeo_video_id(_url)
    pattern = %r{vimeo\.com/(?:video/)?(\d+)}

    url.match(pattern)&.captures&.first
  end
end
