class AddAccountIdToAdminUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :admin_users, :account, index: true, foreign_key: true
  end
end
