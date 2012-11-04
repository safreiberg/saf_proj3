SafProj3::Application.routes.draw do
  get "/posts/show" => "posts#show"
  get "/posts/show/:id" => "posts#show"
  get "/posts/edit" => "posts#edit"
  get "/posts/index" => "posts#index"
  get "/posts/create" => "posts#create"
  get "/posts/new" => "posts#new"
  get "/posts/update" => "posts#update"
  post "/posts/update" => "posts#update"
  
  get "/posts/uppost" => "posts#uppost"
  post "/posts/uppost" => "posts#uppost"  
  get "/posts/downpost" => "posts#downpost"
  post "/posts/downpost" => "posts#downpost"
  
  get "/posts/upcomment" => "posts#upcomment"
  post "/posts/upcomment" => "posts#upcomment"  
  get "/posts/downcomment" => "posts#downcomment"
  post "/posts/downcomment" => "posts#downcomment"
  
  get "/posts/add_comment" => 'posts#add_comment'
  post "/posts/add_comment" => 'posts#add_comment'
  
  get "/posts/add_post" => 'posts#add_post'
  post "/posts/add_post" => 'posts#add_post'
  
  get "/posts/update_comments" => "posts#update_comments"
  post "/posts/update_comments" => "posts#update_comments"
  get "/posts/update_comments/:id" => "posts#update_comments"
  post "/posts/update_comments/:id" => "posts#update_comments"

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
  
  get '/user/top' => 'user#top'
  get '/user/top/update' => 'user#update_top'
  get '/user/show/:id/updateposts' => 'user#update_posts'
  get '/user/show/:id/updatecomments' => 'user#update_comments'
  
  resources :user
  
  get '/' => 'posts#index'
  post '/' => 'posts#index'
  
  get '/welcome/oops' => 'welcome#oops'
  post 'welcome/oops' => 'welcome#oops'
  
  get '/welcome/hello' => 'welcome#hello'
  post '/welcome/hello' => 'welcome#hello'
  
  get '/user/show' => 'user#show'
  post '/user/show' => 'user#show'
  
  get '/user/edit' => 'user#edit'
  post '/user/edit' => 'user#edit'
  

    
  root :to => 'posts#index'
  match '*path' => 'welcome#oops'
end
