require "gatepass/version"
require "gatepass/engine"

module Gatepass
  # Check if the user is defined in the session; if not, redirects to the login page
  def check_authenticated
    if session[:user].nil?
      redirect_to gatepass.authentication_login_path ({ :controller => 'gatepass/authentication', :action => :login })
    end
  end
end
