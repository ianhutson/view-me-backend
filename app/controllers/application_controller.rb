class ApplicationController < ActionController::API  
  def logged_in?
    !!current_user
  end

  def current_user
    return @current_user if @current_user
    if auth_present?
      uid = Auth.decode_uid(read_token_from_request)
      @current_user = User.find_by({uid: uid})
      return @current_user if @current_user
    end
  end
  
private
  def read_token_from_request
    token = request.env["HTTP_AUTHORIZATION"]
                   .scan(/Bearer: (.*)$/).flatten.last
  end
  def auth_present?
    !!request.env.fetch("HTTP_AUTHORIZATION", "")
             .scan(/Bearer/).flatten.first
  end
end