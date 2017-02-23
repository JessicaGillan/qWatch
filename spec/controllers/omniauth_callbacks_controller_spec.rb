require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :request do
  describe 'GET facebook' do
    let(:friends){ create_list(:user_with_fb_account, 5) }
    let(:user){ create(:user) }
    let(:auth) do
                {
                  provider: "facebook",
                  uid: "8",
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

    before do
      User.destroy_all
    end

    context 'for a new user signing up with facebook' do
      it 'creates a user from auth ' do
        friends # Call here so friends are created before request

        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.to change(User, :count).by 1
      end

      it 'adds fb friends to the user it creates' do
        # p Friending.all
        #
        #   get user_facebook_omniauth_callback_url({ auth: auth })

        expect{
          get user_facebook_omniauth_callback_url({ auth: auth })
        }.to change(Friending, :count).by 5
      end
    end

    context 'for an existing user adding a facebook account with a different email address than they signed up with' do
    end

    context 'for an existing user adding a facebook account with the same email address that they signed up with' do
    end
  end
end
