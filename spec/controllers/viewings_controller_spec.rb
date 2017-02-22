require 'rails_helper'

RSpec.describe ViewingsController, type: :request do

  context 'without a signed in user' do
    let(:watchable){ create(:watchable) }

    describe 'POST #create' do
      it 'should not allow a viewing to be created' do
        expect {
          post watch_viewings_url(watchable), xhr: true
        }.to_not change(Viewing, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'GET #index' do
      it 'should not return viewed items' do
        get viewings_url, xhr: true

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  context 'with a signed in user' do
    let(:watchable){ create(:watchable) }
    let(:user){ create(:user) }

    let(:viewing){ { viewed_at: Time.now, title: watchable.title, tmdb_id: watchable.tmdb_id, tmdb_type: 'movie' } }

    before do
      sign_in user
    end

    describe 'POST #create' do
      before do
        post watch_viewings_url(watchable), xhr: true
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it 'should return the information for the viewing it created as json object' do
        expect(json).to be_a Hash
      end

      it 'should create a viewing for the current_user'
      it 'should not try to create a viewing for an item that the user has already viewed'
    end

    describe 'GET #index' do
    end
  end

end
