class AddAccountIdToStudies < ActiveRecord::Migration[7.0]
  def change
    add_reference :studies, :account, index: true, foreign_key: true
  end
end
