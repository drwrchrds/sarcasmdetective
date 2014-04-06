class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @statuses = @user.fetch_statuses!
  end

  def index
    @users = User.all
  end

  def create
    twitter_handle = user_params[:twitter_handle].delete('@')
    @user = User.get_by_twitter_handle(twitter_handle)
    redirect_to user_url(@user)
  end

  private

  def user_params # strong parameters
    params.require(:user).permit(:twitter_handle)
  end

end
