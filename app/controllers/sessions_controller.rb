# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)

    # same as @user && @user.authenticate
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        # remembers the @user if the box is checked, forgets otherwise
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or(@user)
      else
        message = 'Account not activated. '
        message += 'Check your email for activation link'
        flash[:warning] = message
        redirect_to(root_url)
      end
    else
      flash.now[:danger] = 'Invalid email / password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'You have successfully logged out'
    redirect_to root_url
  end
end
