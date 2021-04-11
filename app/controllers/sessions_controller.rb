require "rest-client"
require "json"
require "twitch-api"

class SessionsController < ApplicationController
  def new
    user = User.new
  end

  def create 
      session_code = params[:code]
      response = RestClient.post("https://id.twitch.tv/oauth2/token", { :client_id => "#{ENV["id"]}", :client_secret => "#{ENV["secret"]}", :code => session_code, :grant_type => "authorization_code", :redirect_uri => "auth/twitch" })
      access_token = JSON.parse(response)["access_token"]
      session[:token] = access_token
      client = Twitch::Client.new(:access_token => session[:token], :with_raw => true)
      user = client.get_users(:access_token => access_token).data.first
    @profile_data = { :image => user.profile_image_url, :name => user.display_name, :twitch_id => user.id }
    if Profile.find_by(@profile_data) == nil
      @profile = Profile.new(@profile_data)
      @profile.save
      render json: UserSerializer.new(@profile_data)
    else
      @profile = Profile.find_by(@profile_data)
      render json: UserSerializer.new(@profile_data)
    end
    @profile_data = session[:profile_data]  
  end 

  def is_logged_in?
    if logged_in? && current_user
      render json: {
        logged_in: true,
        user: current_user
      }
    else
      render json: {
        logged_in: false,
        message: 'no such user'
      }
    end
  end

  def destroy 
      session.clear
       
      render json: {
          notice: "succesfully logged out"
      }, status: :ok
  end 

  
end