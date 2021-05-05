require "twitch-api"
require 'json'
require 'uri'
require 'net/http'
require 'httplog'
class SessionsController < ApplicationController

  def create
    session_code = params[:code]
    url = "https://id.twitch.tv/oauth2/token?"
    extras = "client_id="+"#{ENV["id"]}"+"&client_secret="+"#{ENV["secret"]}"+"&code="+"#{session_code}"+"&grant_type=authorization_code&redirect_uri=http://localhost:3000"
    headers = {
      :client_id => "#{ENV["id"]}",
      :client_secret => "#{ENV["secret"]}",
      :code => "#{session_code}",
      :grant_type => "authorization_code",
      :redirect_uri => "http://localhost:3001/auth/twitch/callback"
    }
    uri = URI.parse(url)
    response = Net::HTTP::post_form(uri, headers)
    access_token = JSON.parse(response.body)["access_token"]
    session[:token] = access_token
    client = Twitch::Client.new(:client_id => "#{ENV["id"]}", :client_secret => "#{ENV["secret"]}", token_type: :user, redirect_uri: "http://localhost:3001/auth/twitch/callback", :access_token => session[:token], :with_raw => true)
    user = client.get_users({access_token: session[:token]}).data.first
    data = user
    puts "yo"
    puts data.methods
    @profile_data = { :image => data.profile_image_url, :name => data.display_name, :twitch_id => data.id}
    @user = User.find_or_create_by(name: @profile_data[:name], image: @profile_data[:image], twitch_id: @profile_data[:image])
    if @user
      login!
    render json: {
      logged_in: true,
      user: @profile_data
    }
    else
    render json: { 
      status: 401,
      errors: ['no such user, please try again']
    }
    end
    
    # if User.find_by(@profile_data) == nil
    #   @profile = User.new(@profile_data)
    #   @profile.save
    #   redirect_to generate_url("http://localhost:3000", :id => data.id) 
    # else
    #   @profile = User.find_by(@profile_data)
    #   redirect_to generate_url("http://localhost:3000", :code => data.id) 
    # end
    # @profile_data = session[:profile_data] 
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

private
end