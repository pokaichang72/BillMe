class PagesController < ApplicationController

  def welcome

    if current_user
      redirect_to root_path
    else
      render :layout => 'base'
    end
  end
end
