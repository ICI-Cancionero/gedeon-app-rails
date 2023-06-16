class HomeController < ApplicationController
  def show
    redirect_to home_redirect_url
  end

  def app
    @songs = Song.all.order(title: :asc)
  end

  private

  def home_redirect_url
    ENV.fetch("HOME_REDIRECT_TO") { "/app" }
  end
end
