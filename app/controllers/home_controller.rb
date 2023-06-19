class HomeController < ApplicationController
  def show
    redirect_to home_redirect_url
  end

  def app
    @q = Song.ransack(params[:q])
    @songs = @q.result(distinct: true).order(title: :asc).all
  end

  private

  def home_redirect_url
    ENV.fetch("HOME_REDIRECT_TO") { "/app" }
  end
end
