FactoryBot.define do
  factory :song do
    add_attribute(:title) { Faker::Name.name }
  end
end