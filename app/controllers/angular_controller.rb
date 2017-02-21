class AngularController < ApplicationController
  def index
    cookies[:fb_app_id] = Rails.application.secrets.fb_app_id
  end
end
