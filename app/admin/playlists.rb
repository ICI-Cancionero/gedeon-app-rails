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
    end

    f.inputs do
      f.has_many :playlist_sections, heading: 'Secciones', allow_destroy: true do |ps|
        ps.input :name
        ps.has_many :playlist_items, heading: 'Canciones', allow_destroy: true do |pi|
          pi.input :position
          pi.input :song
        end
      end
    end
    f.actions
  end

  permit_params :name,
                :active,
                playlist_sections_attributes: [
                  :id,
                  :name,
                  :_destroy,
                  playlist_items_attributes: [:id, :position, :song_id, :_destroy]
                ]

end
