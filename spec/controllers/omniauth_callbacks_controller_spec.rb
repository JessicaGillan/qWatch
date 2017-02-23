require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :request do
  describe 'GET facebook' do
    let(:friends){ create_list(:user_with_fb_account, 5) }
    let(:user){ create(:user) }
    let(:auth) do
                {
                  provider: "facebook",
                  uid: "100",
                  info: {
                    email: "unsavedUser@example.com",
                    name: "Johnny Rocket",
                    friends: {
                      data: {
                             "0": { id: friends[0].authentications[0].uid },
                             "1": { id: friends[1].authentications[0].uid},
                             "2": { id: friends[2].authentications[0].uid},
                             "3": { id: friends[3].authentications[0].uid},
                             "4": { id: friends[4].authentications[0].uid }
                            }
                    }
                  },
                  credentials: {
                    expires_in: 6000,
                    token: "12345678910"
                  }
                }
              end

    context 'for a new user signing up with facebook' do
      it 'creates a user from auth ' do
        friends # Call here so friends are created before request

        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.to change(User, :count).by 1
      end

      it 'adds fb friends to the user it creates' do
        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.to change(Friending, :count).by 5
      end
    end

    context 'for an existing user adding a facebook account with a different email address than they signed up with' do
      before do
        sign_in user
        auth
      end

      it 'adds a UserAuthentication for that user' do
        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.to change(user.authentications, :count).by 1
      end

      it 'add facebook friends to that user' do
        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.to change(user.initiated_friendings, :count).by 5
      end

      it 'does not create a new user' do
        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.not_to change(User, :count)
      end

      it 'does not change the user\'s email address' do
        before = user.email

        get user_facebook_omniauth_callback_url({ auth: auth })

        expect(user.email).to eq before
      end
    end

    context 'for an existing user adding a facebook account with the same email address that they signed up with' do
      before do
        sign_in user
        auth[:info][:email] = user.email
      end

      it 'does not create a new User' do
        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.not_to change(User, :count)
      end

      it 'adds a UserAuthentication to that user' do
        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.to change(user.authentications, :count).by 1
      end

      it 'adds facebook friends to that user' do
        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.to change(user.initiated_friendings, :count).by 5
      end
    end
  end
end
