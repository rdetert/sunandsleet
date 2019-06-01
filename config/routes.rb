Rails.application.routes.draw do

	get '/:zipcode' => 'forecasts#show', as: 'forecast'
  resources :forecasts, only: [:create]

  root "main#dashboard"
end
