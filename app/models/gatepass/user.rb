module Gatepass
  class User < ApplicationRecord
    has_secure_password
  end
end
