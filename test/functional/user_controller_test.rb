require 'test_helper'

class UserControllerTest < ActionController::TestCase
  test "new" do
    get :new
    assert_not_nil assigns['user']
  end
  
  test "show" do 
    # Should be robust against incorrect ID
    get :show, id: users(:stephen).id
    assert_response :success
    assert_equal assigns['user'], users(:stephen)
    assert_select 'h2', users(:stephen).username
    
    get :show, id: 124125321
    assert_response :success
    assert_nil assigns['user']
    assert_select 'h1', 'No user was found. Sorry!'
  end
  
  test 'update posts' do
    # Should be robust against incorrect ID
    get :update_posts, id: users(:stephen).id
    assert_response :success
    assert_equal assigns['posts'].length, users(:stephen).posts.length
    # Check that the posts are assigned
    assigns['posts'].each do |p|
      assert users(:stephen).posts.include? p
    end
    
    get :update_posts, id: 332544
    assert_response :success
    assert_equal assigns['posts'], []
  end
  
  test 'update comments' do
    # Should be robust against incorrect ID
    get :update_comments, id: users(:stephen).id
    assert_response :success
    assert_equal assigns['comments'].length, users(:stephen).posts.length
    # Check that the posts are assigned
    assigns['comments'].each do |p|
      assert users(:stephen).comments.include? p
    end
    
    get :update_comments, id: 332544
    assert_response :success
    assert_equal assigns['comments'], []
  end
  
  test 'update stats' do 
    get :update_stats, id: users(:stephen).id
    assert_response :success
    assert_equal assigns['user'], users(:stephen)
    
    get :update_stats, id: 21942114
    assert_response :success
    assert_nil assigns['user']
  end
  
  test 'edit' do
    # Users are currently final
    get :edit, id: users(:stephen).id
    assert_response :success
    
    get :edit
    assert_response :success
  end
  
  test 'top' do 
    get :top, id: users(:stephen).id
    assert_response :success
    assert_select 'h1', 'Top Users'
    
    get :top
    assert_response :success
    assert_select 'h1', 'Top Users'
  end
  
  test 'create' do
    post :create, user: {email: "test@test.com", username: "test", password: "t", password_confirmation: "t"}
    assert_redirected_to :root
    assert_equal User.find_by_email("test@test.com"), get_current_user
    assert_equal get_current_user.comment_karma, 0
    assert_equal get_current_user.link_karma, 0
    set_current_user nil
    
    # bad confirmation
    post :create, user: {email: "test2@test.com", username: "test2", password: "t", password_confirmation: 'bad'}
    assert_nil get_current_user
    assert_redirected_to '/user/new'
    
    set_current_user nil
    # already existing
    post :create, user: {email: "saf@mit.edu", password: "a", password_confirmation: 'a'}
    assert_redirected_to :root
    assert_equal users(:stephen), get_current_user
        
    set_current_user nil
    # already existing: bad confirmation
    post :create, user: {email: "test@test.com", username: "test", password: "bad", password_confirmation: 'bad'}
    assert_response :success
    assert_equal get_current_user, nil
  end
  
  test 'set admin' do
    # Not admin
    get :set_admin, {id: users(:stephen).id, bool: "true"}
    assert_redirected_to :root
    users(:stephen).reload
    assert_equal users(:stephen).admin, false
    
    set_current_user(users(:admin))
    get :set_admin, {id: users(:stephen).id, bool: "true"}
    assert_redirected_to '/user/' + users(:stephen).id.to_s
    users(:stephen).reload
    assert_equal users(:stephen).admin, true
    
    get :set_admin, {id: users(:stephen).id, bool: "false"}
    assert_redirected_to '/user/' + users(:stephen).id.to_s
    users(:stephen).reload
    assert_equal users(:stephen).admin, false
  end
end