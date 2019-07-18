Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #post "registrations/signup" ,to: "registrations#signup"		#user
  #post "registrations/login" ,to: "registrations#login" 		#session 
  #post "registrations/check" , to: "registrations#check"		#get specific data of users
  #post "registrations/forgot" , to: "registrations#forgot"		#reset
  #get "registrations/reset" , to: "registrations#reset" 		#reset
  

  #post "registrations/password_change" , to: "registrations#password_change" 	#reset
  #get "registrations/confirm" , to: "registrations#confirm"						#user					

  #delete "registrations/logout" ,to: "registrations#logout"						#session

  # Refactoring


  #users routes
  #post '/signup' , to: "users#signup" 	
  #get '/confirm' , to: "users#confirm"  # question??? patch
  #get  '/check' ,to: "users#check"

  resources :users , only: [:create, :show]
  get 'confirm_user' , to: "users#verify"

  #sessions routes
  #post '/login' ,to: "sessions#create"
  #delete '/logout' , to: "sessions#destroy"

  resources :sessions, only: [:create, :destroy ]

  #resets routes
  #post '/forgot' , to: "resets#create"
  #get '/password_change' , to: "resets#edit"
  #post '/password_change' , to: "resets#update" #question?? patch

  resources :resets , only: [:create, :edit]
  post 'password_reset' , to: "resets#password_reset"


end
