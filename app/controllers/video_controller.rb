class VideoController < ApplicationController
  
  def gera_video
    tokenGerado = get_secure_token(params[:caminho]).to_s
    @video = Video.new({path: params[:caminho],status:false,token:tokenGerado})
    @video.save
    respond_to do |format|
      #format.json { render json: @video.map { |video| { path: URI.join(root_url, get_secure_path(video.path).to_s) }}}
      #format.json { render json: { path: URI.join(root_url, get_secure_path(@video.path).to_s) }}
      format.json { render json: { path: params[:caminho], token: tokenGerado }}
    end
  end

  def exibe_video
    respond_to do |format|
      format.mp4 { send_file File.join(["/mnt/Vids", params[:caminho1], params[:caminho2] + ".mp4"]), :type => 'video/mp4', :disposition => :inline, :stream => true, :buffer_size  =>  4096 }
    end
  end

end
