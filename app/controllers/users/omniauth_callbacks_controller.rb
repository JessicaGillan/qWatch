class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # GET|POST /resource/auth/facebook
  def passthru
    super
  end

  # GET|POST /users/auth/twitter/callback
  def failure
    redirect_to root_path
  end

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"] || params["auth"])

    if @user.persisted?
      puts "user persisted"
      sign_in @user, :event => :authentication #this will throw if @user is not activated

      puts "current user:"
      p current_user

      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?

      render json: @user
    else
      puts "user not persisted"
      session["devise.facebook_data"] = request.env["omniauth.auth"] || params["auth"]
      redirect_to new_user_registration_url
    end
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end


# https://localhost:3000/api/v1/users/auth/facebook/callback?code=AQDGN528xbiDpSgGCXda_kuNBMXXK67bsV1TYiZuodMypuz7411DrBazmT9rBjbFJWW6p2DOVLkUNgG6ZU0mGrXnL3b_Ykr_oelGcjjuAG18vpPuA8OuwAq-h1jnPfOGExY3vudsBRLPtWLJtiYBwZdJ-62V61Cld-isv3tDjhHF6MYlmV6-_5U9lX1qWqHwpNNt6ix0yi094Qym8R-USyZN3u-S_NZwnM-S6qujGXug7h8hKtIHTJkwCceZGOU4B79t16HUPyEB7ekm1aZNG23YvqAkEafTmSgeaMDwKhLEXzflmHXQnC27sPTajSvg8TMhZfzvCwxL83LVUgZW_fHxKWPaAQQ2qoec2GgNXM1XZg&state=d84b0033874e8932d4eee7596c85c825832dbc0c61a94a8d#_=_
