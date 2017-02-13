require 'rails_helper'

RSpec.describe WatchController, type: :controller do
  before do
    FactoryGirl.create_list(:watchable, 10)
  end

  describe 'GET #index' do
    it 'returns an array of all Watchables' do
      process :index

      expect(JSON.parse(response.body).length).to eq(Watchable.count)
      expect(JSON.parse(response.body)).to eq(JSON.parse(Watchable.all.to_json))
    end
  end

  describe 'GET #show' do
    it 'returns an array of all Watchables' do
      process :show

      expect(JSON.parse(response.body).length).to eq(1)
      expect(JSON.parse(response.body)).to eq(JSON.parse(Watchable.all.to_json))
    end
  end

end