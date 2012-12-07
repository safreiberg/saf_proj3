require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  test "show with valid post" do
    get :show, id: 1
    assert_response :success
    assert_equal assigns["post"], posts(:one)
    assert_not_nil assigns["comment"]
  end
  
  test "show with invalid post" do
    get :show, id: 219412423
    assert_response :success
    assert_select "h1", "No post was found. Sorry!"
  end
  
  # Create, Edit, and New are not used, and should redirect to the
  # root url.
  test "get edit" do
    get :edit
    assert_redirected_to :root
  end
  test "get new" do
    get :new
    assert_redirected_to :root
  end
  test "get create" do 
    get :create
    assert_redirected_to :root
  end
  
  # Index should contain all of the posts in the DB.
  test "get index" do
    get :index
    assert_response :success
    Post.find(:all).each do |p|
      assert assigns["posts"].include? p
    end
  end
  
  # Uppost, downpost, upcomment, downcomment all require
  # authentication.
  test "get and post uppost no authentication" do
    get :uppost
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
    
    post :uppost, id: 1
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
  end
  
  test "get and post downpost no auth" do
    get :downpost
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
    
    post :downpost, id: 1
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
  end
  
  test "get and post upcomment no auth" do
    get :upcomment
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
    
    post :upcomment, id: 1
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
  end
  
  test "get and post downcomment no auth" do
    get :downcomment
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
    
    post :downcomment, id: 1
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
  end
  
  # Uppost, with proper identification
  test "get and post uppost, proper auth" do
    set_current_user(users(:stephen))

    get :uppost
    assert_response :success
    
    post :uppost, id: posts(:one).id
    assert_response :success
    
    # Even with a crazy ID, uppost should not fail.
    post :uppost, id: 3241294
    assert_response :success
  end
  
  # Downpost, with proper identification
  test "get and post downpost, proper auth" do
    set_current_user(users(:stephen))
    
    get :downpost
    assert_response :success
    
    post :downpost, id: posts(:one).id
    assert_response :success
    
    # Even with a crazy ID, downpost should not fail.
    post :downpost, id: 3241294
    assert_response :success
  end
  
  # Upcomment, with proper identification
  test "get and post upcomment, proper auth" do
    set_current_user(users(:stephen))
    
    get :upcomment
    assert_response :success
    
    post :upcomment, id: posts(:one).id
    assert_response :success
    
    # Even with a crazy ID, downpost should not fail.
    post :upcomment, id: 3241294
    assert_response :success
  end
  
  # Downcomment, with proper identification
  test "get and post downcomment, proper auth" do
    set_current_user(users(:stephen))
    
    get :downcomment
    assert_response :success
    
    post :downcomment, id: comments(:one).id
    assert_response :success
    
    # Even with a crazy ID, downpost should not fail.
    post :downcomment, id: 3241294
    assert_response :success
  end
  
  # Add comment requires authentication
  test "add comment no auth" do
    get :add_comment
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
    
    post :add_comment, user_id: 1, post_id: 1, content: "lol"
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
  end
  
  # Add post requires authentication.
  test "add post no auth" do
    get :add_post
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
    
    post :add_post, user_id: 1, content: "lol", title: "hehe"
    assert_redirected_to :root
    assert_equal flash[:error], "You must be logged in to access this section"
  end
  
  test "add post with auth" do
    set_current_user(users(:stephen))
    
    # GET shouldn't create a Post without params.
    assert_difference('Post.count',0) do
      get :add_post
      assert_response :success
    end
    
    # GET should create a Post with params.
    assert_difference('Post.count', 1) do
      get :add_post, user_id: 1, content: "lol", title: "hehe"
    end
    
    # POST should create a Post.
    assert_difference('Post.count', 1) do
      post :add_post, user_id: 1, content: "lol", title: "hehe"
    end
    
    # Shouldn't be able to change rank of new Post.
    post :add_post, user_id: 1, content: "lol", title: "test1", \
      rank: 5, upvotes: 10, downvotes: 5
    p = Post.find_by_title("test1")
    assert_equal p.upvotes, 0
    assert_equal p.downvotes, 0
    assert_equal p.rank, 0
    
    # Shouldn't be able to change rank of new Post.
    get :add_post, user_id: 1, content: "lol", title: "test2", \
      rank: 5, upvotes: 10, downvotes: 5
    p = Post.find_by_title("test2")
    assert_equal p.upvotes, 0
    assert_equal p.downvotes, 0
    assert_equal p.rank, 0
    
    # Shouldn't be able to post as imposter.
    assert_difference('Post.count',0) do
      post :add_post, user_id: 2, content: "lol", title: "test3", \
            rank: 5, upvotes: 10, downvotes: 5
      assert_response :success
    end
    
    # Shouldn't be able to post as imposter.
    assert_difference('Post.count',0) do
      get :add_post, user_id: 2, content: "lol", title: "test4", \
            rank: 5, upvotes: 10, downvotes: 5
      assert_response :success
    end
  end
  
  test "add comment with auth" do
    set_current_user(users(:stephen))
    
    # GET shouldn't create a Comment without params.
    assert_difference('Comment.count',0) do
      get :add_comment
      assert_response :success
    end
    
    # GET should create a Comment with params.
    assert_difference('Comment.count', 1) do
      get :add_comment, user_id: 1, content: "lol", post_id: 1
    end
    
    # POST should create a Comment.
    assert_difference('Comment.count', 1) do
      post :add_comment, user_id: 1, content: "lol", post_id: 1
    end
    
    # Shouldn't be able to change rank of new Comment.
    post :add_comment, user_id: 1, content: "test1", post_id: 1, \
      rank: 5, upvotes: 10, downvotes: 5
    p = Comment.find_by_content("test1")
    assert_equal p.upvotes, 0
    assert_equal p.downvotes, 0
    assert_equal p.rank, 0
    
    # Shouldn't be able to change rank of new Comment.
    get :add_comment, user_id: 1, content: "test2", post_id: 1, \
      rank: 5, upvotes: 10, downvotes: 5
    p = Comment.find_by_content("test2")
    assert_equal p.upvotes, 0
    assert_equal p.downvotes, 0
    assert_equal p.rank, 0
    
    # Shouldn't be able to comment as imposter.
    assert_difference('Comment.count',0) do
      post :add_comment, user_id: 2, content: "test3", post_id: 1, \
            rank: 5, upvotes: 10, downvotes: 5
      assert_response :success
    end
    
    # Shouldn't be able to comment as imposter.
    assert_difference('Comment.count',0) do
      get :add_comment, user_id: 2, content: "test4", post_id: 1, \
            rank: 5, upvotes: 10, downvotes: 5
      assert_response :success
    end
  end
  
  # Update does not require authentication.
  test "update posts" do
    get :update
    assert_response :success
    # First a sanity check, then an in depth ordered check.
    assert_not_nil assigns['posts']
    assert_equal assigns['posts'].length, Post.count
    
    # Check for uniqueness and ordering
    r = 1.0 / 0.0 # infinity
    seen = []
    ps = assigns['posts']
    ps.each do |p|
      assert r >= p.rank, "rank should be weakly decreasing"
      assert_equal seen.include?(p), false
      seen << p
      r = p.rank
    end
  end
  
  # Update Comments does not require authentication.
  test "update comments" do
    # GET shouldn't return anything without params.
    get :update_comments
    assert_response :success
    assert_equal assigns['comments'], []
    
    # GET should work with params.
    get :update_comments, id: 1
    assert_response :success
    assert_not_nil assigns['comments']
    assert_equal assigns['comments'].length, Comment.find_all_by_post_id(1).length
    
    # Check for uniqueness and ordering
    r = 1.0 / 0.0 # infinity
    seen = []
    ps = assigns['comments']
    ps.each do |p|
      assert r >= p.rank, "rank should be weakly decreasing"
      assert_equal seen.include?(p), false
      seen << p
      r = p.rank
    end
    
    # Same as above, with Post
    post :update_comments, id: 1
    assert_response :success
    assert_not_nil assigns['comments']
    assert_equal assigns['comments'].length, Comment.find_all_by_post_id(1).length
    
    # Check for uniqueness and ordering
    r = 1.0 / 0.0 # infinity
    seen = []
    ps = assigns['comments']
    ps.each do |p|
      assert r >= p.rank, "rank should be weakly decreasing"
      assert_equal seen.include?(p), false
      seen << p
      r = p.rank
    end
  end
  
  # Test the delete functionality for posts
  test "delete posts" do    
    # Nothing should happen without current user
    assert_difference('Post.count',0) do
      get :delete_post, id: posts(:one)
      assert_redirected_to :root
      
      post :delete_post, id: posts(:one)
      assert_redirected_to :root
    end
    
    # Nothing should happen without admin
    set_current_user(users(:stephen))
    assert_difference('Post.count',0) do
      get :delete_post, id: posts(:one)
      assert_redirected_to :root
      
      post :delete_post, id: posts(:one)
      assert_redirected_to :root
    end
    
    # Admin can delete posts
    set_current_user(users(:admin))
    assert_difference('Post.count',-1) do
      id = posts(:one).id
      get :delete_post, id: posts(:one)
      assert_response :success
      assert_equal Comment.find_all_by_post_id(id), []
      assert_equal PostVote.find_all_by_post_id(id), []
    end 
  end
  
  # Test the delete functionality for comments
  test "delete comments" do
    # Nothing should happen without current user
    assert_difference('Comment.count',0) do
      get :delete_comment, id: comments(:one)
      assert_redirected_to :root
      
      post :delete_comment, id: comments(:one)
      assert_redirected_to :root
    end
    
    # Nothing should happen without admin
    set_current_user(users(:stephen))
    assert_difference('Comment.count',0) do
      get :delete_comment, id: comments(:one)
      assert_redirected_to :root
      
      post :delete_comment, id: comments(:one)
      assert_redirected_to :root
    end
    
    # Admin can delete comments
    set_current_user(users(:admin))
    assert_difference('Comment.count',-1) do
      id = comments(:one).id
      get :delete_comment, id: comments(:one)
      assert_response :success
      assert_equal CommentVote.find_all_by_comment_id(id), []
    end 
  end
end