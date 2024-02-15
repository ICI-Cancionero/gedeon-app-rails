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
class Scripture < ApplicationRecord
  acts_as_tenant(:account)
  belongs_to :playlist_section
  has_one :playlist, through: :playlist_section

  serialize :verses, Array

  def bible_reference
    "#{book_id} #{chapter_num} : #{from} #{to.present? ? "- #{to}" : nil}"
  end
end
