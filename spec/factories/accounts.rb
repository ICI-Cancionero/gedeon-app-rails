# == Schema Information
#
# Table name: accounts
#
#  id         :bigint           not null, primary key
#  name       :string
#  subdomain  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_accounts_on_subdomain  (subdomain)
#
FactoryBot.define do
  factory :account do
    name { "MyString" }
    subdomain { "MyString" }
  end
end
