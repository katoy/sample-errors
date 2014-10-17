Rails.application.routes.draw do
  resources :users

  get "test" => 'users#test'
  get  '*not_found' => 'application#render_404'
end
