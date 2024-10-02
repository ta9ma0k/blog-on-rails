class FolloweesController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find_by(name: followee_params[:username])

    if user.present? && current_user.follow(user)
      @followee_posts = user.posts.preload(:user, :thumbnail_attachment, likes: :user, comments: :user)
      flash.now.notice = "#{user.name}をフォローしました"
    else
      flash.now.alert = "フォローできませんでした"
    end
  end

  private

  def followee_params = params.permit(:username)
end
