AccessControl::Application.routes.draw do

  root :to                      => 'home#index'
  get '/videos/:caminho', 	to: 'video#gera_video'
  get '/video/:caminho', 	to: 'video#exibe_video'
end
