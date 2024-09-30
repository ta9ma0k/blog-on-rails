class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    filter = params[:filter]

    unless user_signed_in?
      @posts = Post.preload(:user).recently
    else
      @posts = case filter
               when 'follow' then
                 current_user.followee_posts.recently
               else
                 Post.preload(:user).recently
               end
    end
  end

  def create
    @post = current_user.post(post_params[:body])

    render :new, status: :unprocessable_entity if @post.nil?
  end

  private

  def post_params = params.require(:post).permit(:body)
end
