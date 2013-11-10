NustAlumni::Application.routes.draw do
  devise_for :users, :skip => [:registrations, :sessions, :passwords]

  root :to                             => 'application#comingsoon'
  match '/404/'                        => 'application#not_found',  :via => :GET
  match '/500/'                        => 'application#exception',  :via => :GET

  namespace :api, defaults: {format: 'json'} do
    root :to                           => 'api#null'
    
    namespace :v1 do
      root :to                         => 'v1#index'
      match '/me/valid/'               => 'user#validsession',      :via => :GET

      match '/user/new/'			   => 'user#new',	 		    :via => :POST
      match '/user/logout/'            => 'user#logout',            :via => :POST
      match '/user/login/'             => 'user#login',             :via => :POST
    end
  end 
end
