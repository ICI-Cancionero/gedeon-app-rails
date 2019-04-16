class Api::V1::PlaylistsController < ApplicationController

  def show
    @playlist = Playlist.find(params[:id])
    render json: @playlist
  end

  def index
    render json: Playlist.active.includes(playlist_sections: [playlist_items: [:song]]), include: "playlist_sections,playlist_sections.playlist_items"
  end
end
