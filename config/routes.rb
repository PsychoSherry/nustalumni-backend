NustAlumni::Application.routes.draw do
  root :to  => 'application#comingsoon'
  match '/404/'					=> 'application#not_found',  :via => :GET
  match '/500/'                 => 'application#exception',  :via => :GET

  # namespace :parse, defaults: {format: 'json'} do
  # 	match '/user/:user/'							=> 'fetch#user',	    :via => :GET
  # 	match '/user/:user/again'						=> 'fetch#useragain',	:via => :GET
  # 	match '/user/:user/tweets/from/:from/to/:to/'	=> 'fetch#tweets',      :via => :GET
  end
end
