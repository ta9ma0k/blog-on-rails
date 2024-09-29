class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    @posts = Post.preload(:user).recently
  end

  def create
    @post = current_user.post(post_params[:body])

    render :new, status: :unprocessable_entity if @post.nil?
  end

  private

  def post_params = params.require(:post).permit(:body)
end
