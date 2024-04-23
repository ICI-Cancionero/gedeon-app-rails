class AddRawContentToStudies < ActiveRecord::Migration[7.0]
  def change
    add_column :studies, :raw_content, :text
  end
end
