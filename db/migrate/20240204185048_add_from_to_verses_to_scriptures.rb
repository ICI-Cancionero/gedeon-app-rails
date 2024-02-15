class AddFromToVersesToScriptures < ActiveRecord::Migration[7.0]
  def change
    add_column :scriptures, :from, :integer
    add_column :scriptures, :to, :integer
  end
end
