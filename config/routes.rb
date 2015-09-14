AccessControl::Application.routes.draw do

  root :to                      => 'home#index'
  get '/dev'                    => 'home#dev'
  get '/html5'                  => 'home#html5'
  get '/videos/:caminho', 	to: 'video#gera_video'
  get '/video/:caminho1/:caminho2', 	to: 'video#exibe_video'
  get '/video/:caminho1', 	to: 'video#exibe_video'
  get '/videohtml5/:caminho1/:caminho2', 	to: 'video#exibe_video_html5'
  get '/videohtml5/:caminho1', 	to: 'video#exibe_video_html5'
end
