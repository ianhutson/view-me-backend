require "rest-client"
require "json"
require "twitch-api"

class UsersController < ApplicationController

  def index
    @users = User.all
    render json: @users
  end

  def create
    user = User.new(user_params)
    if user.save
        render json: UserSerializer.new(user)
    end
  end

  private 
  
  def user_params
    params.require(:user).permit(:name, :image, :twitch_id)
  end

end

