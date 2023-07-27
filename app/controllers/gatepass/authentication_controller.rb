module Gatepass
  # Provides the login/logout functionality
  class AuthenticationController < ApplicationController
    # Display the login form
    def login
    end

    # Remove the user from the session and redirect to the login form
    def logout
      session.delete :user
      redirect_to  :action => :login
    end

    # Process the POST from the login form
    def authenticate
      username = params[:username]
      password = params[:password]

      user = User.find_by(username: username)
      if user.auth_type == 'local'
        user_obj = user.authenticate(password)

        if user_obj === false
          redirect_to ({ controller: 'gatepass/authentication', action: 'login' })
        else
          session[:user] = user_obj
          redirect_to main_app.root_url
        end
      elsif user.auth_type == 'activedirectory' # 'ldap'
        require 'net/ldap'

        server_address = Rails.application.config.ldap_server_hostname
        server_port = Rails.application.config.ldap_server_port
        ca_certificate = Rails.application.config.ldap_ca_cert

        ldap = Net::LDAP.new :host => server_address,
                             :port => server_port,  # 636, # 389,
                             :encryption => {
                               method: :simple_tls,
                               tls_options: {
                                 ca_file: ca_certificate
                                 # verify_mode: OpenSSL::SSL::VERIFY_NONE
                               }
                             },
                             :auth => {
                               :method => :simple,
                               :username => user.username_mapping,
                               :password => password
                             }

        filter = Net::LDAP::Filter.eq("distinguishedname", user.username_mapping)
        treebase = Rails.application.config.ldap_base

        search_result_count = 0
        ldap.search(:base => treebase, :filter => filter) do |entry|
          search_result_count += 1

          if ldap.get_operation_result.code == 49 or search_result_count == 0
            redirect_to({ controller: 'gatepass/authentication', action: 'login' })
          elsif search_result_count == 1
            session[:user] = user # entry
            redirect_to main_app.root_url
          else
            redirect_to({ controller: 'gatepass/authentication', action: 'login' })
          end
        end
      end
    end
  end
end
