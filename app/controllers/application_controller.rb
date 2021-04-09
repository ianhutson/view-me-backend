require "jwt"

class ApplicationController < ActionController::Base
  before_action :authenticate_request
  attr_reader :current_user

  private

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    !!current_user
  end

end
