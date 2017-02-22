require 'rails_helper'

RSpec.describe AngularController, type: :request do
  describe 'GET index' do
    before do
      get root_url
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it 'sets the fb_app_id in a cookie for the angular app to use' do
      expect(response.cookies['fb_app_id'].length).to be >= 16
    end
  end
end
