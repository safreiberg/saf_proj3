require 'test_helper'

class LoginsTest < ActionDispatch::IntegrationTest
  def test_login_simple
  ## Go to login page
    get "/login"
    assert_response :success
    
    ## Login via post
    post_via_redirect "/session/create", { :email => "saf@mit.edu", :password => "a" }
    assert_equal 1, session[:user_id]
    assert_equal true, session[:authenticated]
    assert_equal '/', path
    assert_equal 'Successfully logged in.', flash[:notice]
    
    ## Logout
    get "/logout"
    assert_response :redirect
    follow_redirect!
    assert_not_equal 1, session[:user_id]
    assert_not_equal true, session[:authenticated]
  end
  
  def test_make_user
  ## Go to login page
    get "/login"
    assert_response :success
    
    ## Login via post
    post_via_redirect "/user/create", {:user => {:email => "test@test.com", :password => "a", 
      :password_confirmation => "a", :username => 'test' }}
    assert_equal 3, session[:user_id]
    assert_equal true, session[:authenticated]
    assert_equal '/', path
    assert_equal 'Your account has been created.', flash[:notice]
    
    ## Logout
    get "/logout"
    assert_response :redirect
    follow_redirect!
    assert_not_equal 3, session[:user_id]
    assert_not_equal true, session[:authenticated]
    
    
    ## Login via post
    post_via_redirect "/session/create", { :email => "test@test.com", :password => "a" }
    assert_equal 3, session[:user_id]
    assert_equal true, session[:authenticated]
    assert_equal '/', path
    assert_equal 'Successfully logged in.', flash[:notice]
  end
end