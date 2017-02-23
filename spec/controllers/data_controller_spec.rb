require 'rails_helper'

RSpec.describe DataController, type: :request do
  describe 'GET index' do

    context 'with data mined from a permitted service' do
      it "returns http success" do
        post data_url(service: "netflix", watchables: [create(:watchable)])

        expect(response).to have_http_status(:success)
      end
    end

    context 'with data mined from an unpermitted service' do
      it 'returns error' do
        post data_url(service: "unpermitted", watchables: [create(:watchable)])

        expect(response).to have_http_status(:error)
        expect(json["error"]).not_to be_falsey
      end

    end
  end
end
