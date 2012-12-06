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
end