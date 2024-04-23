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
class Study < ApplicationRecord
  acts_as_tenant(:account)

  before_save :set_raw_content

  private

  def set_raw_content
    # Parse the HTML content using Nokogiri
    doc = Nokogiri::HTML(self.content.to_s)

    # Extract text from the parsed HTML
    plain_text = doc.text.strip

    # Remove any extra whitespace characters
    plain_text.gsub!(/\s+/, ' ')

    self.raw_content = plain_text
  end
end
