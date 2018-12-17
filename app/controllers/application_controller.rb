# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper # Adds sessions helper for use by all controller

  def current_user_feed
    current_user.feed.paginate(page: params[:page])
  end

  private

  # Confirms a logged in user, will be called in users_controller
  def logged_in_user
    return if logged_in? # if logged in, allow to do actions

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
end
