class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    rel = if user_signed_in? && params[:filter] == "follow"
            current_user.followee_posts
    else
            Post
    end
    @posts = rel.preload(:user, :thumbnail_attachment, likes: :user, comments: :user).recently
  end

  def create
    @post = current_user.post(post_params[:body], post_params[:thumbnail])

    render :new, status: :unprocessable_entity if @post.nil?
  end

  private

  def post_params = params.require(:post).permit(:body, :thumbnail)
end
