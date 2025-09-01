# == Schema Information
#
# Table name: studies
#
#  id          :bigint           not null, primary key
#  content     :text
#  raw_content :text
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint
#
# Indexes
#
#  index_studies_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
FactoryBot.define do
  factory :study do
    title { "MyString" }
    content { "MyText" }
  end
end
