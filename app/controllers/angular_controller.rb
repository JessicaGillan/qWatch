# Public: Main Controller to serve front-end angular app
#
class AngularController < ApplicationController
  def index
    # set a fb_app_id cookie for facebook js-sdk script
    cookies[:fb_app_id] = Rails.application.secrets.fb_app_id
  end
end
