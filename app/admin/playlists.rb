ActiveAdmin.register Playlist do

  permit_params :name, :active, song_ids: []

  index do
    selectable_column
    id_column
    column :name
    list_column :song_titles
    toggle_bool_column :active
    actions
  end

  show do
    attributes_table do
      row :name
      row :active
      list_row :song_titles
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :active
      f.input :songs, as: :select, collection: Song.pluck(:title, :id)
    end
    f.actions
  end

end
