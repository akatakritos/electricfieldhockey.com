class SessionsController < ApplicationController

  def new
    redirect_to user_path(current_user) if signed_in?
  end

  def create
    if signed_in?
      redirect_to user_path(current_user)
    else
      user = User.find_by_username(params[:session][:username].downcase)
      if user && user.authenticate(params[:session][:password])
        sign_in user
        flash[:success] = "Welcome back, #{user.username}"
        redirect_back_or levels_path
      else
        flash.now[:error] = signin_error_message
        render 'new'
      end
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
