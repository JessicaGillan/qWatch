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
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
