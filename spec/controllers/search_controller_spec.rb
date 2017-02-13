require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  before do
    FactoryGirl.create_list(:watchable, 10)
  end

  describe 'GET #index' do
    it 'returns an array of search results' do
      process :index, params: { search: "test" }

      expect(JSON.parse(response.body)).to eq(JSON.parse(Watchable.title_search("test").to_json))
    end

    it 'only returns matched results' do
      process :index, params: { search: "test 1" }

      expect(JSON.parse(response.body)).to eq(JSON.parse(Watchable.where(title: 'Test 1').to_json))
    end
  end
end
