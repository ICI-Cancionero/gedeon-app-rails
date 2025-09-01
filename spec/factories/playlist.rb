FactoryBot.define do
  factory :playlist do
    association :account
    add_attribute(:name) { Faker::Name.name }
    add_attribute(:active) { true }

    trait :with_section do
      association :playlist_sections, factory: :playlist_section
    end
  end
end
