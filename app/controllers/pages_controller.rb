class PagesController < ApplicationController
  before_action :login_required, only: [:friends]

  def welcome
    if current_user
      redirect_to root_path
    else
      render :layout => 'base'
    end
  end

  def friends
    @graph = Koala::Facebook::API.new(current_user.fbtoken)
    @friends = @graph.get_connections("me", "friends")
  end
end
