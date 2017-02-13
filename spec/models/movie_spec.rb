require 'rails_helper'

RSpec.describe Movie, type: :model do

  describe '.populate_db_titles' do
    it 'gets and saves movie titles and movie_api ids'
  end

  describe '.populate_watchables_data' do
    it 'gets and saves third party link info for a set of watchables'
  end

end
