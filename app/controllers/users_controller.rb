require "rest-client"
require "json"
require "twitch-api"

class UsersController < ApplicationController

  def index
    @users = User.all
    render json: @users
  end

  def create
    session_code = params[:code]
    response = RestClient.post("https://id.twitch.tv/oauth2/token", { :client_id => "#{ENV["CLIENT_ID"]}", :client_secret => "#{ENV["CLIENT_SECRET"]}",
                                                                      :code => session_code, :grant_type => "authorization_code", :redirect_uri => "/" })
    access_token = JSON.parse(response)["access_token"]
    session[:token] = access_token
    client = Twitch::Client.new(:access_token => session[:token], :with_raw => true)
    user = client.get_users(:access_token => access_token).data.first
    @profile_data = { :image => user.profile_image_url, :name => user.display_name, :twitch_id => user.id }
    if User.find_by(@profile_data) == nil
      @user = User.create(@profile_data)
      redirect_to user_path(@user)
    else
      @user = User.find_by(@profile_data)
      redirect_to user_path(@user)
    end
    @profile_data = session[:profile_data] 
  end

  def show
    @user = User.find(params[:id])
  end
end