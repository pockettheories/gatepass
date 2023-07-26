module Gatepass
  class AuthenticationController < ApplicationController
    def login
    end

    def logout
      session.delete :user
      redirect_to  :action => :login
    end

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

        server_address = Rails.application.config.ldap_server_hostname  # 'ad.nitinkatkam.mdbrecruit.net'
        server_port = Rails.application.config.ldap_server_port
        ca_certificate = Rails.application.config.ldap_ca_cert

        ldap = Net::LDAP.new :host => server_address,
                             :port => server_port,  # 636, # 389,
                             :encryption => {
                               method: :simple_tls,
                               tls_options: {
                                 ca_file: ca_certificate  # '/Users/nitin.katkam/Downloads/nitinkatkam-ad-ca.cer',
                                 # verify_mode: OpenSSL::SSL::VERIFY_NONE
                               }
                             },
                             :auth => {
                               :method => :simple,
                               :username => user.username_mapping,
                               :password => password
                             }

        filter = Net::LDAP::Filter.eq("distinguishedname", user.username_mapping)
        treebase = Rails.application.config.ldap_base  # "dc=nitinkatkam, dc=mdbrecruit, dc=net"

        search_result_count = 0
        ldap.search(:base => treebase, :filter => filter) do |entry|
          search_result_count += 1
          # puts "DN: #{entry.dn}" # CN=bindUser1,CN=Users,DC=nitinkatkam,DC=mdbrecruit,DC=net
          # puts "memberOf: #{entry.memberof}" #["CN=peopleOfNitinKatkam,CN=Users,DC=nitinkatkam,DC=mdbrecruit,DC=net", "CN=Administrators,CN=Builtin,DC=nitinkatkam,DC=mdbrecruit,DC=net"]

          if ldap.get_operation_result.code == 49 or search_result_count == 0
            redirect_to({ controller: 'gatepass/authentication', action: 'login' })
          elsif search_result_count == 1
            session[:user] = user # entry  # user_obj
            redirect_to main_app.root_url
          else
            redirect_to({ controller: 'gatepass/authentication', action: 'login' })
          end
        end
      end
    end
  end
end
