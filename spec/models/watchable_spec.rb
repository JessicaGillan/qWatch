require 'rails_helper'

RSpec.describe Watchable, type: :model do
  let(:watch) { create(:watchable) }

  describe '#full_details' do
    it 'updates the watchable if its details haven\'t been requested yet' do
      expect(watch).to receive(:update_url_info)
      watch.full_details
    end

    it 'does not update the watchable if it has already been set' do
      watch.full_details

      expect(watch).not_to receive(:update_url_info)
      watch.full_details
    end

    it 'returns a watchable object' do
      expect(watch.full_details).to be_a Watchable
    end

    it 'returns a the same object if it has already been requested' do
      updated_watch = watch.full_details

      expect(updated_watch.full_details).to eq updated_watch
    end
  end

end
