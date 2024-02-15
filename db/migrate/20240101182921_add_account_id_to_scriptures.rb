class AddAccountIdToScriptures < ActiveRecord::Migration[7.0]
  def change
    add_reference :scriptures, :account, index: true, foreign_key: true
  end
end
