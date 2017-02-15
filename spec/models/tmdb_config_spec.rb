require 'rails_helper'

RSpec.describe TMDBConfig, type: :model do

  describe '.get' do

    let(:config) { build(:tmdb_config) }

    it 'returns a Config Hash' do
      expect(config.sizes).to be_a Array
      expect(config.sizes[0]).to be_a String
      expect(config.url).to be_a String
      expect(config.secure_url).to be_a String
    end

  end

end
