class ApplicationController < ActionController::Base
  set_current_tenant_by_subdomain(:account, :subdomain)
end
