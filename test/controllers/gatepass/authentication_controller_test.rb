require "test_helper"

module Gatepass
  class AuthenticationControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "should get login" do
      get authentication_login_url
      assert_response :success
    end

    test "should get logout" do
      get authentication_logout_url
      assert_response :success
    end

    test "should get authenticate" do
      get authentication_authenticate_url
      assert_response :success
    end
  end
end
