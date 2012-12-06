require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  test "go to login page" do
    # We just need to check that the page is displayed.
    get :new
    assert_response :success
    assert_select "h2", "Log in"
  end
  
  test "create new session (log in)" do
    # Fake email should not login
    post :create, email: "fake@fake.com", password: "fake"
    assert_response :success
    assert_select "h2", "Log in"
    assert_nil get_current_user
    
    # Wrong password should not login
    post :create, email: "saf@mit.edu", password: "fake"
    assert_response :success
    assert_select "h2", "Log in"
    assert_nil get_current_user
    
    # Correct password should login
    post :create, email: "saf@mit.edu", password: "a"
    assert_redirected_to :root
    assert_equal get_current_user, users(:stephen)
  end
  
  test "destroy" do
    # Without prior login
    get :destroy
    assert_nil get_current_user
    assert_redirected_to :root
    
    # With prior login
    set_current_user(users(:stephen))
    assert_equal users(:stephen), get_current_user
    get :destroy
    assert_nil get_current_user
    assert_redirected_to :root
  end
end
