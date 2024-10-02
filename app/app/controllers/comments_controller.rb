class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find_by(id: comment_params[:post_id])

    flash.now.alert = "コメントできませんでした" unless @post.present? && current_user.comment(@post, comment_params[:body])
  end

  private

  def comment_params = params.permit(:post_id, :body)

  def redirect_path = request.referer || root_path
end
