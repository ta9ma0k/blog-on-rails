class PostsController < ApplicationController
  def index
    @posts = Post.recently
  end

  def create
    @post = Post.new(post_params)

    render :new, status: :unprocessable_entity unless @post.save
  end

  private

  def post_params = params.require(:post).permit(:body)
end
