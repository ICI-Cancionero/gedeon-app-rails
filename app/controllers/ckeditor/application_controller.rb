class Ckeditor::ApplicationController < ApplicationController
  before_action :authenticate_admin_user!
  skip_before_action :verify_authenticity_token
  
  private
  
  def authenticate_admin_user!
    # Add your authentication logic here
    # For now, just ensure the user is authenticated through your existing system
    redirect_to admin_root_path unless current_admin_user
  end
end