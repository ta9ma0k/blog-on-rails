class FolloweesController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find_by(name: followee_params[:username])

    if user.present? && current_user.follow(user)
      redirect_to root_path
    else
      redirect_to root_path, alert: "フォローできませんでした"
    end
  end

  private

  def followee_params = params.permit(:username)
end
