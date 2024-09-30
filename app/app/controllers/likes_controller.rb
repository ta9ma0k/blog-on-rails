class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find_by(id: like_params)

    if post.present? && current_user.like(post)
      redirect_to redirect_path
    else
      redirect_to redirect_path, alert: "いいねできませんでした"
    end
  end

  private

  def like_params = params.require(:post_id)

  def redirect_path = request.referer || root_path
end
