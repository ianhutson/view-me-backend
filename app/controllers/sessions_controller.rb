require "twitch-api"
require 'json'
require 'uri'
require 'net/http'
require 'httplog'
class SessionsController < ApplicationController

  def new
    user = User.new
  end
  
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
    puts "yo"
    data = user
    puts data
    @profile_data = { :image => data.profile_image_url, :name => data.login, :twitch_id => data.id }
    if User.find_by(@profile_data) == nil
      @profile = User.new(@profile_data)
      @profile.save
      redirect_to generate_url("http://localhost:3000", :name => data.login) 
    else
      @profile = User.find_by(@profile_data)
      redirect_to generate_url("http://localhost:3000", :name => data.login) 
    end
    @profile_data = session[:profile_data] 
  end


  private
  def generate_url(url, params = {})
    uri = URI(url)
    uri.query = params.to_query
    uri.to_s
  end
end