class AddBibleVersionToScriptures < ActiveRecord::Migration[7.0]
  def change
    add_column :scriptures, :bible_version, :string
  end
end
