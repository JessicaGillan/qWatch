class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    params["auth"]['credentials']['expires_at'] = params["auth"]['credentials']['expires_in'] ? params["auth"]['credentials']['expires_in'].to_i.seconds.from_now : nil
    create
  end

  def twitter
    create
  end

  def google
    create
  end

  private

    def check_signed_in
      if user_signed_in?
        render json: current_user.as_json(include: [:authentications]), status:200
      else
        render json: {error: "sign in failed"}, status: 422
      end
    end

    def create
      auth_params = request.env["omniauth.auth"] || params["auth"]
      authentication = UserAuthentication.find_by(provider:auth_params["provider"], uid: auth_params["uid"])
      existing_user = current_user || User.find_by(email: auth_params['info']['email'])

      if authentication
        sign_in_with_existing_authentication(authentication)
      elsif existing_user
        create_authentication_and_sign_in(auth_params, existing_user)
      else
        create_user_and_authentication_and_sign_in(auth_params)
      end
    end

    def sign_in_with_existing_authentication(authentication)
      sign_in(authentication.user)
      check_signed_in
    end

    def create_authentication_and_sign_in(auth_params, user)
      UserAuthentication.create_from_omniauth(auth_params, user)

      sign_in(user)
      check_signed_in
    end

    def create_user_and_authentication_and_sign_in(auth_params)
      user = User.create_from_omniauth(auth_params)
      if user.valid?
        create_authentication_and_sign_in(auth_params, user)
      else
        render json: {error: user.errors.full_messages.first}, status: 422
      end
    end
end
