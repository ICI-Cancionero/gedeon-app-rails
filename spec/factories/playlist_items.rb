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
FactoryBot.define do
  factory :playlist_item do
    sequence(:position) { |n| n }

    trait :with_song do
      association :song, factory: :song
    end
  end
end
