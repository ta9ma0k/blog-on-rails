class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find_by(id: comment_params[:post_id])

    if @post.present? && current_user.comment(@post, comment_params[:body])
      flash.now.notice = "コメントしました"
    else
      flash.now.alert = "コメントできませんでした"
    end
  end

  private

  def comment_params = params.permit(:post_id, :body)

  def redirect_path = request.referer || root_path
end
