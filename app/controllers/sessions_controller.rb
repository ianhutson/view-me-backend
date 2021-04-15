require "rest-client"
require "json"
require "twitch-api"

class SessionsController < ApplicationController

  def new
    user = User.new
  end
  
  def create
    session_code = params[:code]
    response = RestClient.post("https://id.twitch.tv/oauth2/token", { :client_id => "#{ENV["id"]}", :client_secret => "#{ENV["secret"]}",
    :code => session_code, :grant_type => "client_credentials", :redirect_uri => "http://localhost:3000" })
    access_token = JSON.parse(response)["access_token"]
    session[:token] = access_token

    client = Twitch::Client.new( client_id: "#{ENV["id"]}",
    client_secret: "#{ENV["secret"]}",
    token_type: :user, :access_token => session[:token], :with_raw => true)
    puts "yo"
    puts client.access_token
    user = client.get_users(:access_token =>  client.access_token).data.first
    @profile_data = { :image => user.profile_image_url, :name => user.display_name, :twitch_id => user.id }
    if User.find_by(@profile_data) == nil
      @profile = User.new(@profile_data)
      @profile.save
    else
      @profile = User.find_by(@profile_data)
    end
    @profile_data = session[:profile_data] 
  end


  private
 def random_password
  (0...8).map{(65 + rand(26)).chr}.join
 end
end