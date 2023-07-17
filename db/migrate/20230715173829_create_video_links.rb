class CreateVideoLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :video_links do |t|
      t.string :url, null: false
      t.integer :provider, default: 0, null: false
      t.string :video_id
      t.timestamps
    end
  end
end
