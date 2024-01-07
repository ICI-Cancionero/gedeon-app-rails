class CreateScriptures < ActiveRecord::Migration[7.0]
  def change
    create_table :scriptures do |t|
      t.string  :book_id
      t.string  :chapter_num
      t.text    :verses
      t.text   :content

      t.timestamps
    end
  end
end
