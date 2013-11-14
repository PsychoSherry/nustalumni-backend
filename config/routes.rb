NustAlumni::Application.routes.draw do
  devise_for :users, :skip => [:registrations, :sessions, :passwords]

  root :to                             => 'application#comingsoon'
  match '/404/'                        => 'application#not_found',  :via => :GET
  match '/500/'                        => 'application#exception',  :via => :GET

  namespace :api, defaults: {format: 'json'} do
    root :to                           => 'api#null'
    
    namespace :v1 do
      root :to                         => 'v1#index'

      match '/user/'                   => 'user#show',              :via => :GET
      match '/user/'                   => 'user#update',            :via => :POST
      match '/user/me/'                => 'user#validsession',      :via => :GET
      match '/user/new/'               => 'user#new',               :via => :POST
      match '/user/logout/'            => 'user#logout',            :via => :POST
      match '/user/login/'             => 'user#login',             :via => :POST
      match '/user/password/'          => 'user#password',          :via => :POST

      match '/data/home/'              => 'data#home',              :via => :GET
      match '/data/faq/'               => 'data#faq',               :via => :GET
      match '/data/people/'            => 'data#people',            :via => :GET
    end
  end 
end
