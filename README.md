# Gatepass
Short description and motivation.

## Usage
See the Installation section below.

For setting up a DEV environment, clone the directory within a rails project and add to the Gemfile:
```
gem 'gatepass', path: 'gatepass'
```
OR
```
gem 'gatepass', git: 'https://github.com/pockettheories/gatepass'
```
See [Bundle Git Guide](https://bundler.io/guides/git.html) for more

## Installation
Add this line to your application's Gemfile:

```ruby
gem "gatepass"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install gatepass
```
OR
```bash
$ bundle add gatepass
```

Mount the engine with the following line in `config/routes.rb` :
```
mount Gatepass::Engine => '/gatepass'
```
Ensure you also have the root configured (Eg. `root 'home#index''`) for your Rails application.

Modify the application controller to include the Gatepass module and add the authentication check:
```
class ApplicationController < ActionController::Base
  include Gatepass
  before_action :check_authenticated
end
```

In `config/application.rb` , define the following configuration parameters:
```
config.ldap_server_hostname = 'myldap.com'
config.ldap_server_port = 636
config.ldap_ca_cert = '/etc/path/ca.cert'
config.ldap_base = 'DN=myldap,DN=com'
```

Run the migrations with:
```
rails gatepass:install:migrations
rails db:migrate
```

Create an initial user account with:
```
$ rails c
u1 = Gatepass::User.new
u1.username = 'nitin'
u1.password = 'green'
u1.auth_type = 'local'
u1.save
```

Create an initial ActiveDirectory user account with:
```
$ rails c
u1 = Gatepass::User.new
u1.username = 'reddy'
u1.password = 'dummy'
u1.auth_type = 'activedirectory'
u1.rolename = 'admin'
u1.username_mapping = 'CN=reddy,CN=Users,DC=pockettheories,DC=com'
u1.save
```

Login with the above account, and access the user account management page at:
http://localhost:3000/gatepass/users

The logout URL is:
http://localhost:3000/gatepass/authentication/logout

## Other Notes
The User model has the fields: username:string auth_type:string password_digest:string username_mapping:string
auth_type is `local` or `activedirectory`.
Use a dummy password for activedirectory users.

If you get the error "SSL_CTX_load_verify_file: system lib" when attempting to login as an ActiveDirectory user, it's 
Ruby complaining about your OpenSSL version. (On MacOS Ventura 13.4.1, rbenv with Ruby 3.1.0 works; Ruby 3.2.2 doesn't)

## Contributing
Create a pull request on GitHub.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
