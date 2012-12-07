SafProj3::Application.routes.draw do
  # Routes for show / index / etc on Posts.
  get "/posts/show" => "posts#show"
  get "/posts/show/:id" => "posts#show"
  get "/posts/edit" => "posts#edit"
  get "/posts/index" => "posts#index"
  get "/posts/create" => "posts#create"
  get "/posts/new" => "posts#new"
  get "/posts/update" => "posts#update"
  post "/posts/update" => "posts#update"
  
  # Routes for upvoting and downvoting comments and 
  # posts.
  get "/posts/uppost" => "posts#uppost"
  post "/posts/uppost" => "posts#uppost"  
  get "/posts/downpost" => "posts#downpost"
  post "/posts/downpost" => "posts#downpost"
  get "/posts/upcomment" => "posts#upcomment"
  post "/posts/upcomment" => "posts#upcomment"  
  get "/posts/downcomment" => "posts#downcomment"
  post "/posts/downcomment" => "posts#downcomment"
  
  # Routes for adding comments and posts.
  get "/posts/add_comment" => 'posts#add_comment'
  post "/posts/add_comment" => 'posts#add_comment'
  get "/posts/add_post" => 'posts#add_post'
  post "/posts/add_post" => 'posts#add_post'
  
  # Routes for deleting comments and posts.
  post "/posts/delete_post/:id" => "posts#delete_post"
  get "/posts/delete_post/:id" => "posts#delete_post"
  post "/posts/delete_comment/:id" => "posts#delete_comment"  
  get "/posts/delete_comment/:id" => "posts#delete_comment"  
  
  # Routes for updating comment views.
  get "/posts/update_comments" => "posts#update_comments"
  post "/posts/update_comments" => "posts#update_comments"
  get "/posts/update_comments/:id" => "posts#update_comments"
  post "/posts/update_comments/:id" => "posts#update_comments"

  # Routes for signin, signup, and logout.
  get '/session/new' => 'session#new'
  post '/session/new' => 'session#new'
  get '/session/create' => 'session#create'
  post '/session/create' => 'session#create'
  get '/login' => 'session#new'
  post '/login' => 'session#new'
  get '/signup' => 'user#new'
  post '/signup' => 'user#new'
  get '/user/create' => 'user#create'
  post '/user/create' => 'user#create'
  get '/user/new' => 'user#new'
  post '/user/new' => 'user#new'
  get '/logout' => 'session#destroy'
  post '/logout' => 'session#destroy'
  
  # Routes for updating user views
  get '/user/top' => 'user#top'
  get '/user/top/update' => 'user#update_top'
  get '/user/show/:id/updateposts' => 'user#update_posts'
  get '/user/show/:id/updatecomments' => 'user#update_comments'
  get '/user/show/:id/updatestats' => 'user#update_stats'
  
  # Routes for viewing user resources.
  resources :user
  get '/user/set_admin/:id/:bool' => 'user#set_admin', as: :admin_path
  get '/user/show' => 'user#show'
  post '/user/show' => 'user#show'
  get '/user/edit' => 'user#edit'
  post '/user/edit' => 'user#edit'
  
  # Routes for default behavior and error checking.
  get '/' => 'posts#index'
  post '/' => 'posts#index'
  get '/welcome/oops' => 'welcome#oops'
  post 'welcome/oops' => 'welcome#oops'
  get '/welcome/hello' => 'welcome#hello'
  post '/welcome/hello' => 'welcome#hello'
  
  # Route to catch remaining paths.
  root :to => 'posts#index'
  match '*path' => 'welcome#oops'
end
