ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Songs" do
          ul do
            Song.order('created_at desc').limit(5).map do |song|
              li link_to(song.title, admin_song_path(song))
            end
          end
        end
      end
      column do
        panel "Recent Playlists" do
          ul do
            Playlist.order('created_at desc').limit(5).map do |playlist|
              li link_to(playlist.name, admin_playlist_path(playlist))
            end
          end
        end
      end
      column do
        panel "Recent Scriptures" do
          ul do
            Scripture.order('created_at desc').limit(5).map do |scripture|
              li link_to(scripture.bible_reference, admin_scripture_path(scripture))
            end
          end
        end
      end
    end
  end # content
end
