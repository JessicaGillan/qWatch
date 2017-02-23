require 'rails_helper'

RSpec.describe WatchController, type: :controller do
  before do
    Watchable.reindex
    FactoryGirl.create_list(:watchable, 40)
  end

  describe 'GET #index' do
    it 'returns an array of all Watchables' do
      process :index

      expect(JSON.parse(response.body).length).to eq(Watchable.count)
      expect(JSON.parse(response.body)).to eq(JSON.parse(Watchable.all.to_json))
    end

    it 'accepts a page and limit parameter' do
      process :index, params: { page: 1, limit: 10}
      expect(JSON.parse(response.body).length).to eq(10)
      process :index, params: { page: 2, limit: 10}
      expect(JSON.parse(response.body)[0]["id"]).to eq(11)

    end
  end

  describe 'GET #show' do
    it 'returns a watchable with full details' do
      process :show, params: {id: Watchable.first.tmdb_id}

      expect(JSON.parse(response.body)).to eq(JSON.parse(Watchable.first.to_json))
    end
  end

end
