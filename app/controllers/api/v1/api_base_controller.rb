class Api::V1::ApiBaseController < ApplicationController
  before_action :set_default_tentant

  def set_default_tentant
    if current_tenant.nil?
      ActsAsTenant.current_tenant = Account.find_by(subdomain: "ici-santiago")
    end
  end
end
