# == Schema Information
#
# Table name: scriptures
#
#  id                  :bigint           not null, primary key
#  chapter_num         :string
#  content             :text
#  from                :integer
#  to                  :integer
#  verses              :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint
#  book_id             :string
#  playlist_section_id :bigint
#
# Indexes
#
#  index_scriptures_on_account_id           (account_id)
#  index_scriptures_on_playlist_section_id  (playlist_section_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require 'rails_helper'

RSpec.describe Scripture, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
