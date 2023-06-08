class HomeController < ApplicationController
  def show
    redirect_to home_redirect_url
  end

  def app
  end

  private

  def home_redirect_url
    ENV.fetch("HOME_REDIRECT_TO") { "/app" }
  end
end
