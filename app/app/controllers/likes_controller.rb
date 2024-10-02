class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find_by(id: like_params)

    if @post.present? && current_user.like(@post)
      flash.now.notice = "いいねしました"
    else
      flash.now.alert = "いいねできませんでした"
    end
  end

  private

  def like_params = params.require(:post_id)

  def redirect_path = request.referer || root_path
end
