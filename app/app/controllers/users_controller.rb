class UsersController < ApplicationController
  def profile
    @user = User.find_by(name: params[:username])
    raise ActiveRecord::RecordNotFound if @user.nil?
  end
end
