Rails.application.routes.draw do

	get ':zipcode' 	=> 'forecasts#show', as: 'forecast'
	get '95765' 		=> 'forecasts#show', as: 'rocklin'
  resources :forecasts, only: [:create]

  root to: redirect('95765')
end
