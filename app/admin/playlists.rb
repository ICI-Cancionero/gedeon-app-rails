ActiveAdmin.register Playlist do
  menu priority: 4

  permit_params :name,
                :active,
                playlist_sections_attributes: [
                  :id,
                  :name,
                  :_destroy,
                  playlist_items_attributes: [:id, :position, :song_id, :_destroy],
                  scriptures_attributes: [:id, :book_id, :chapter_num, :content, :from, :to]
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
      list_row :bible_references
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form partial: 'form'

  action_item :view, only: [:show, :slides] do
    link_to 'View PDF', view_pdf_admin_playlist_path(playlist, format: :pdf), target: "_blank"
  end

  action_item :duplicate, only: :show do
    link_to 'Duplicate', duplicate_admin_playlist_path(playlist)
  end

  action_item :slides, only: :show do
    link_to 'Presentation', slides_admin_playlist_path(playlist), target: "_blank"
  end

  member_action :slides, method: :get do
    @playlist = resource

    render layout: "reveal_js"
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

  controller do
    before_action :set_bible, only: [:new, :edit]

    def set_bible
      bible_path = Rails.root.join("lib/open-bibles/NVI-utf8.xmm.xml")
      @bible = BibleParser.new(File.open(bible_path))
    end
  end
end
