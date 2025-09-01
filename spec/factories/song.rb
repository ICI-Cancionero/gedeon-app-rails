FactoryBot.define do
  factory :song do
    association :account
    add_attribute(:title) { Faker::Name.name }
  end
end