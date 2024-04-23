class CreateStudies < ActiveRecord::Migration[7.0]
  def change
    create_table :studies do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
