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

    let(:viewed_item){ { viewed_at: Time.now, title: watchable.title, tmdb_id: watchable.tmdb_id, tmdb_type: 'movie' } }

    before do
      sign_in user
    end

    describe 'POST #create' do

      it "returns http success" do
        post watch_viewings_url(watch_id: watchable.tmdb_id), xhr: true
        expect(response).to have_http_status(:success)
      end

      it 'should return the information for the viewing it created with the tmdb_id as json object' do
        post watch_viewings_url(watch_id: watchable.tmdb_id), xhr: true
        expect(json).to be_a Hash
      end

      it 'should create a viewing for the current_user based of tmdb_id' do
        expect {
          post watch_viewings_url(watch_id: watchable.tmdb_id), xhr: true
        }.to change(Viewing, :count).by 1

        expect(json.keys).to include("viewed_at", "title", "tmdb_id", "tmdb_type")
      end

      it 'should not create a viewing for an item that the user has already viewed' do
        post watch_viewings_url(watch_id: watchable.tmdb_id), xhr: true

        expect {
          post watch_viewings_url(watch_id: watchable.tmdb_id), xhr: true
        }.to_not change(Viewing, :count)
      end
    end

    describe 'GET #index' do
      context 'with out a paramater passed' do
        before do
          post watch_viewings_url(watch_id: watchable.tmdb_id), xhr: true
          get viewings_url, xhr: true
        end

        it 'returns http success' do
          expect(response).to have_http_status(:success)
        end

        it 'returns an array of viewed items' do
          expect(json).to be_an Array
        end

        it 'returns the current user\'s viewed items' do
          expect(json[0]["tmdb_id"]).to eq viewed_item[:tmdb_id]
        end
      end

      context 'with the :friends_viewings parameter passed' do
        it 'returns an array of viewed items' do
          post watch_viewings_url(watch_id: watchable.tmdb_id), xhr: true
          get viewings_url, xhr: true

          expect(json).to be_an Array
        end

        it 'returns the recently viewed items of the current user\'s friends' do
          watchable
          user = create(:user_with_friends, friends_count: 2)

          user.friends.each do |friend|
            friend.viewed_items << Watchable.first
          end

          sign_in user

          get viewings_url(friends_viewings: "true"), xhr: true

          expect(json.length).to eq user.friends.length

          expect(json[0].keys).to include("viewed_at", "friend", "title", "tmdb_id")
        end
      end

    end
  end

end
