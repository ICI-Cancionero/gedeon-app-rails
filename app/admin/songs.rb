require 'video_player'

ActiveAdmin.register Song do
  permit_params :title, :content, :position,
                video_links_attributes: [
                  :provider,
                  :url
                ]

  filter :title
  filter :content
  filter :position
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :title
      f.input :position
      f.input :content
    end

    if song.persisted?
      panel "Slide", id: "song-slide" do
        render partial: "iframe", locals: {song: song}
      end
    end

    f.inputs do
      f.has_many :video_links, heading: 'Video Links', allow_destroy: true do |f_vl|
        f_vl.input :provider
        f_vl.input :url
      end
    end

    f.actions
  end

  show do
    attributes_table do
      row :position
      row :title
      row :content do |song|
        simple_format song.content
      end

      row :video_links do |song|
        song.video_links.each do |video_link|
          div do
            raw VideoPlayer::player(video_link.url)
          end
        end
      end

      row :created_at
      row :updated_at
    end

    div do
      h2 do
        "Slide"
      end
      iframe src: slide_admin_song_path(song), width: "100%", height: 500 do
      end
    end
    active_admin_comments
  end

  member_action :slide, method: :get do
    @song = resource

    respond_to do |format|
      format.html { render layout: "reveal_js" }
    end
  end
end
