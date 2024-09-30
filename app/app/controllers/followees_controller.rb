class FolloweesController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find_by(name: followee_params[:name])
    
    render :new, status: :unprocessable_entity unless user.present? && current_user.follow(user)
  end

  private
  
  def followee_params = params.require(:followee).permit(:name)
end
