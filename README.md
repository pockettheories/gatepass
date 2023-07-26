# Gatepass
Short description and motivation.

## Usage
How to use my plugin.

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

Modify the application controller to include the Gatepass module and add the authentication check:
```
class ApplicationController < ActionController::Base
  include Gatepass
  before_action :check_authenticated
end
```

TODO - Configuration parameters

Create an initial user account with:
```
$ rails c
u1 = Gatepass::User.new
u1.username = 'nitin'
u1.password = 'green'
u1.auth_type = 'local'
u1.save
```

Login with the above account, and access the user account management page at:
http://localhost:3000/gatepass/users

## Other Notes
The User model has the fields: username:string auth_type:string password_digest:string username_mapping:string

auth_type is `local` or `activedirectory`.

Use a dummy password for activedirectory users.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
