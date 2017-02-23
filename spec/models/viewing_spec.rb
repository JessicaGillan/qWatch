require 'rails_helper'

RSpec.describe Viewing, type: :model do
  it 'does not allow duplicate Viewings' do
    user = create(:user)
    watchable = create(:watchable)

    user.viewed_items << watchable

    expect{
      user.viewed_items << watchable
    }.to raise_error(ActiveRecord::RecordInvalid)

    expect{
      watchable.viewers << user
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
