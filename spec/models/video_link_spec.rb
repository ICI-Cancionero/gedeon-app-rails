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
require 'rails_helper'

RSpec.describe VideoLink, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
