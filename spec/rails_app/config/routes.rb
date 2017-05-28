# Note this is a barebones routes.rb simply to test the jira_authenticable strategy.
RailsApp::Application.routes.draw do
  devise_for :users, :skip => [:sessions]
  as :admin do
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :users

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'users#index'
end
