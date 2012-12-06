require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  # Since hello and oops are just static pages that
  # are only reached when the wrong thing happens,
  # these automatically generated tests are FINE.
  test "should get oops" do
    get :oops
    assert_response :success
  end

  test "should get hello" do
    get :hello
    assert_response :success
  end
end
