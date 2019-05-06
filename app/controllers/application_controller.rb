class ApplicationController < ActionController::Base

  def append_info_to_payload(payload)
    super
    case
      when payload[:status] == 200
        payload[:level] = "INFO"
      when payload[:status] == 302
        payload[:level] = "WARN"
      else
        payload[:level] = "ERROR"
    end
    payload[:remote_ip] = request.remote_ip
    if current_admin_user
      payload[:user_id] = current_admin_user.id
      payload[:user_email] = current_admin_user.email
    end
    payload[:user_agent] = request.env["HTTP_USER_AGENT"]
  end

end
