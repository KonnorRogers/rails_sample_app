# frozen_string_literal: true

class UsersController < ApplicationController
  def new
  end

  def show
    @user = User.find(params[:id])
    # adds debugging via byebug gem
    # debugger
  end
end
