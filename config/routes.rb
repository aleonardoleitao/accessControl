AccessControl::Application.routes.draw do

  root :to                      			=> 'home#index'
  get '/dev'                    			=> 'home#dev'
  get '/streaming'              			=> 'home#streaming'
  get '/html5'                  			=> 'home#html5'

  get '/videos/:caminho', 					            to: 'video#gera_video'
  post '/videos/:caminho',                       to: 'video#gera_video_streaming'

  get '/video/:caminho1/:caminho2', 		        to: 'video#exibe_video'
  get '/video/:caminho1', 					            to: 'video#exibe_video'

  get '/videostreaming/:caminho1/:caminho2', 		to: 'video#exibe_video_streaming'
  post '/videostreaming/:caminho1/:caminho2',   to: 'video#exibe_video_streaming'
  get '/videostreaming/:caminho1', 					    to: 'video#exibe_video_streaming'
  post '/videostreaming/:caminho1',             to: 'video#exibe_video_streaming'
  
  get '/videohtml5/:caminho1/:caminho2', 	      to: 'video#exibe_video_html5'
  get '/videohtml5/:caminho1', 			            to: 'video#exibe_video_html5'
end
