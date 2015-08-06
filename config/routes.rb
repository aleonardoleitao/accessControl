AccessControl::Application.routes.draw do

  root :to                      => 'home#index'
  get '/dev'                    => 'home#dev'
  get '/videos/:caminho', 	to: 'video#gera_video'
  get '/video/:caminho1/:caminho2', 	to: 'video#exibe_video'
  get '/video/:caminho1', 	to: 'video#exibe_video'

end
