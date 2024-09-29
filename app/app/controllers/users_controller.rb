class UsersController < ApplicationController
  def profile
    @user = User.find_by(name: params[:username])
    render status: :not_found if @user.nil?
  end
end
