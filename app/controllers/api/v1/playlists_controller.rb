module Api
  module V1
    class PlaylistsController < Api::V1::ApiBaseController
      def index
        render json: Playlist.active.includes(playlist_sections: [{ playlist_items: [:song] }]),
               include: 'playlist_sections,playlist_sections.playlist_items'
      end

      def show
        @playlist = Playlist.find(params[:id])
        render json: @playlist
      end
    end
  end
end
