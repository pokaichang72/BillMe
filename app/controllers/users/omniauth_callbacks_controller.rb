class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user
    set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  end
end
