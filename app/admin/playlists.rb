ActiveAdmin.register Playlist do
  permit_params :name,
                :active,
                playlist_sections_attributes: [
                  :id,
                  :name,
                  :_destroy,
                  playlist_items_attributes: [:id, :position, :song_id, :_destroy]
                ]

  scope :active
  scope :inactive

  filter :name
  filter :active
  filter :created_at
  filter :updated_at

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

  action_item :view, only: :show do
    link_to 'View Document', view_pdf_admin_playlist_path(playlist, format: :pdf)
  end

  action_item :duplicate, only: :show do
    link_to 'Duplicate', duplicate_admin_playlist_path(playlist)
  end

  member_action :view_pdf, method: :get do
    @playlist = resource

    respond_to do |format|
      format.pdf do
        render pdf: @playlist.name,
               encoding: 'utf-8',
               layout: 'pdf',
               margin: {
                 top: 20,
                 left: 30,
                 right: 30
               },
               page_size: 'A4',
               lowquality: true,
               zoom: 1,
               dpi: 75
               #show_as_html: true
      end
    end
  end

  member_action :duplicate, method: :get do
    @playlist = resource
    @new_playlist = @playlist.duplicate
    respond_to do |format|
      format.html do
        redirect_to edit_admin_playlist_path(@new_playlist), notice: "You have duplicate the playlist succesfully"
      end
    end
  end
end
