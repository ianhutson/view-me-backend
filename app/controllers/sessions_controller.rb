class SessionsController < ApplicationController
  
  def new
    user = User.new
    render json: user
  end
  
  def create
    session[:user_id] = User.find_or_create_by(name: request.env['omniauth.auth']["info"]['name']).id 
    render json: User.find_or_create_by(name: request.env['omniauth.auth']["info"]['name'])
  end

  def destroy
    session.delete("user_id")
    redirect_to root_url
  end

  private

end