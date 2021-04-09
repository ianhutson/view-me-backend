class AuthenticationController < ApplicationController
    skip_before_action :authenticate_request
  
    def authenticate
     puts params
      command = AuthenticateProfile.call(session[:twitch_id])
  
      if command.success?
        render json: { auth_token: command.result }
      else
        puts command
        render json: { error: command.errors }, status: :unauthorized
      end
    end
  end