class Api::V1::SongsController < ApplicationController
  def show
    @song = Song.find(params[:id])
    render json: @song
  end

  def index
    render json: Song.all
  end
end
