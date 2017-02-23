require 'rails_helper'

RSpec.describe Friending, type: :model do
  it 'does not allow duplicate Friendings' do
    user = create(:user)
    friend = create(:user)

    user.friended_users << friend

    expect{
      user.friended_users << friend
    }.to raise_error(ActiveRecord::RecordInvalid)

    expect{
      friend.friended_users << user
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
