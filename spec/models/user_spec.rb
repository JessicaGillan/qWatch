require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ create(:user) }

  describe '.create_from_omniauth' do
    let(:auth){ { "info": { "email": 'testing@example.com', "name": 'Jerry' } } }

    before do
      auth.stringify_keys!
      auth['info'].stringify_keys!
    end

    it 'creates a user from passed in parameters' do
      expect{
        User.create_from_omniauth(auth)
      }.to change(User, :count).by 1
    end

    it 'will now create two users with the same email address' do
      auth['info']['email'] = user.email

      expect{
        User.create_from_omniauth(auth)
      }.not_to change(User, :count)
    end
  end

  describe '#to_json' do
    it 'includes the user\'s authentications' do
      expect(user.to_json).to match(/authentications/)
    end
  end

  describe '#friends' do
    it 'returns the combination of a user\'s friended_users and users_friended_by' do
      friend1 = create(:user)
      friend2 = create(:user)

      user.friended_users << friend1
      friend2.friended_users << user

      expect(user.friended_users.length).to eq 1
      expect(user.users_friended_by.length).to eq 1
      expect(user.friends.length).to eq 2
    end
  end

  describe '#add_fb_friends' do
    let(:friends){ create_list(:user_with_fb_account, 5) }
    let(:fb_user_info){
                        {
                         "0": { id: friends[0].authentications[0].uid },
                         "1": { id: friends[1].authentications[0].uid},
                         "2": { id: friends[2].authentications[0].uid},
                         "3": { id: friends[3].authentications[0].uid},
                         "4": { id: friends[4].authentications[0].uid }
                        }
                      }

    before do
      fb_user_info.stringify_keys!
      fb_user_info.map{ |key, data| data.stringify_keys! }
    end

    it 'adds a users FB friends that are on qWatch to their friends' do
      friends

      expect{
        user.add_fb_friends(fb_user_info)
      }.to change(user.friended_users, :length).by 5
    end

    it 'does not try to create duplicate Friendings' do
      user.friended_users << friends

      expect{
        user.add_fb_friends(fb_user_info)
      }.not_to raise_error

      expect{
        user.add_fb_friends(fb_user_info)
      }.not_to change(user.friended_users, :length)
    end
  end

  describe '#friends_viewings' do
    context 'for a user with friends' do
      let(:friends){ create_list(:user_with_viewed_items, 5, {items_count: 3}) }

      before do
        user.friended_users << friends
      end

      it 'returns the items that their friends have viewed' do
        expect(user.friends_viewings.length).to eq 15
      end

      it 'returns the viewing date, friend, and watchable info for each item' do
        expect(user.friends_viewings[0].as_json.keys).to include("viewed_at", "friend", "title", "tmdb_id")
      end
    end

    context 'for a user without friends' do
      it 'does not raise an error' do
        expect{
          user.friends_viewings
        }.not_to raise_error
      end

      it 'returns an empty collection' do
        expect(user.friends_viewings).to eq([])
      end
    end
  end

  describe '#viewed_items_with_viewing_date' do
    context 'for a user with viewed_items' do
      let(:user){ create(:user_with_viewed_items, items_count: 5) }

      it 'returns the items that the user has viewed' do
        expect(user.viewed_items_with_viewing_date.length).to eq 5
      end

      it 'returns the viewing date and watchable info for each item' do
        expect(user.viewed_items_with_viewing_date[0].as_json.keys).to include("viewed_at", "title", "tmdb_id", "tmdb_type")
      end
    end

    context 'for a user without viewed_items' do
      it 'does not raise an error' do
        expect{
          user.viewed_items_with_viewing_date
        }.not_to raise_error
      end

      it 'returns an empty collection' do
        expect(user.viewed_items_with_viewing_date).to eq([])
      end
    end
  end
end
