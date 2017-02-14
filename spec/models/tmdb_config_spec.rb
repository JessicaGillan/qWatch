require 'rails_helper'

RSpec.describe TmdbConfig, type: :model do

  describe '.get' do

    let(:config) { build(:tmdb_config) }

    it 'returns a string' do
      expect(config.url).to be_a String
    end

  end

end
