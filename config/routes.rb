SafProj3::Application.routes.draw do
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
  
  resources :user
  
  get '/' => 'welcome#hello'
  post '/' => 'welcome#hello'
  
  get '/welcome/oops' => 'welcome#oops'
  post 'welcome/oops' => 'welcome#oops'
  
  get '/welcome/hello' => 'welcome#hello'
  post '/welcome/hello' => 'welcome#hello'
  
  get '/user/show' => 'user#show'
  post '/user/show' => 'user#show'
  
  get '/user/edit' => 'user#edit'
  post '/user/edit' => 'user#edit'
    
  root :to => 'welcome#hello'
  match '*path' => 'welcome#oops'
end
