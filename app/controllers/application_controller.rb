class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :get_settings

  private

  def login_required
    if current_user.blank?
      respond_to do |format|
        format.html {
          redirect_to login_redirect_path
        }
        format.js{
          render :partial => "common/not_logined"
        }
        format.all {
          head(:unauthorized)
        }
      end
    end
  end

  def login_redirect_path
    "/welcome"
  end

  def get_settings
    @app_name = Setting.app_name
    @google_analytics_id = Setting.google_analytics_id
  end
end
