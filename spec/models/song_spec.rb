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
require 'rails_helper'

RSpec.describe Song, type: :model do
  it { should have_and_belong_to_many(:playlists) }
end
