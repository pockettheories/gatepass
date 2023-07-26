require "gatepass/version"
require "gatepass/engine"

module Gatepass
  def check_authenticated
    if session[:user].nil?
      redirect_to user_auth.authentication_login_path ({ :controller => 'gatepass/authentication', :action => :login })
    end
  end
end
