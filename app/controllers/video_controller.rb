require 'nokogiri'
require 'open-uri'

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
    Rails.logger.info "Iniciando a consulta no exibe video"
    Rails.logger.info params

    token = params[:token] + "&e=" + params[:e]
    video = Video.find_by_token(token)
    tk = params[:tk]
    perfil = params[:perfil]
    resultado = 1
    xml = Nokogiri::XML(open('http://ws.conecte.us/index.asp?id=' + perfil + '&acao=auth_mp4&token=' + URI::encode(tk)))
    itens = xml.search('status').map do |item|
      resultado = item.text
    end

    Rails.logger.info "Resultado da consulta"
    if !video.status && !(resultado == '1')
      video.status = true
      video.save
      respond_to do |format|
        #format.mp4 { send_file File.join(["/mnt/Vids", params[:caminho1], params[:caminho2] + ".mp4"]), :type => 'video/mp4', :disposition => :inline, :stream => true, :buffer_size  =>  4096 }
        format.mp4 { send_file File.join(["/mnt/Vids", params[:caminho1], params[:caminho2] + ".mp4"]), :type => 'video/mp4', :buffer_size  =>  1024 }
        #format.mp4 { send_file File.join(["/mnt/Vids/3000/1000.mp4"]), :type => 'video/mp4', :buffer_size  =>  1024 }
      end
    else
        render(:file => "#{Rails.root}/public/403.html", :status => 403, :layout => false)
    end

  end

end
