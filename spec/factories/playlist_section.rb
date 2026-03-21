FactoryBot.define do
  factory :playlist_section do
    add_attribute(:name) { Faker::Name.name }

    association :playlist, factory: :playlist
  end
end
