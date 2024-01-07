# == Schema Information
#
# Table name: scriptures
#
#  id          :bigint           not null, primary key
#  chapter_num :string
#  content     :text
#  verses      :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint
#  book_id     :string
#
# Indexes
#
#  index_scriptures_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Scripture < ApplicationRecord
  acts_as_tenant(:account)

  serialize :verses, Array
end
