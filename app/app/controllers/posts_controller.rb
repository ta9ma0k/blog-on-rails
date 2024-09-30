class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    if user_signed_in? && params[:filter] == 'follow'
      @posts = current_user.followee_posts.preload(:user, likes: :user).recently
    else
      @posts = Post.preload(:user, likes: :user).recently
    end
  end

  def create
    @post = current_user.post(post_params[:body])

    render :new, status: :unprocessable_entity if @post.nil?
  end

  private

  def post_params = params.require(:post).permit(:body)
end
