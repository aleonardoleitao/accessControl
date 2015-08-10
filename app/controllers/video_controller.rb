require 'nokogiri'
require 'open-uri'

class VideoController < ApplicationController
  
  def gera_video
    tokenGerado = get_secure_token(params[:caminho]).to_s
    @video = Video.new({path: params[:caminho],status:false,token:tokenGerado})
    @video.save
    respond_to do |format|
      format.json { render json: { path: params[:caminho], token: tokenGerado }}
    end
  end

  def exibe_video

    user_agent = request.env['HTTP_USER_AGENT']
    
    chrome = false
    if user_agent =~ /Chrome/
      chrome = true
      Rails.logger.info "Chrome"
    end

    file_path = File.join(["/mnt/Vids", params[:caminho1], params[:caminho2] + ".mp4"])
    file_name = params[:caminho2] + ".mp4"

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
    
    Rails.logger.info "Resultado da consulta - webserver"
    Rails.logger.info resultado
    Rails.logger.info "Resultado da consulta - video token"
    Rails.logger.info video.status

    if !video.status && !(resultado == '1')

      video.status = true
      video.save

      if(request.headers["HTTP_RANGE"]) && !chrome

        size = File.size(file_path)
        bytes = Rack::Utils.byte_ranges(request.headers, size)[0]
        offset = bytes.begin
        length = bytes.end  - bytes.begin

        response.header["Accept-Ranges"]=  "bytes"
        response.header["Content-Range"] = "bytes #{bytes.begin}-#{bytes.end}/#{size}"
        
        Rails.logger.info "bytes #{bytes.begin}-#{bytes.end}/#{size}"
        Rails.logger.info "Iniciando o envio IOS"
        send_data IO.binread(file_path,length, offset), :type => "video/mp4", :stream => true,  :disposition => 'inline', :file_name => file_name
        Rails.logger.info "Arquivo enviado IOS"

      else
        Rails.logger.info "Exibindo videos apenas para o chrome"
        Rails.logger.info file_path
        respond_to do |format|
          format.mp4 { send_file(file_path, :disposition => 'inline', :stream => true, :file_name => file_name, :type => 'video/mp4', :buffer_size  =>  1024 )}
        end
        Rails.logger.info "Finalizando videos do chrome"
      end

    else
      render(:file => "#{Rails.root}/public/403.html", :status => 403, :layout => false)
    end
  end

  #def exibe_video
    #Rails.logger.info "Iniciando a consulta no exibe video"
    #Rails.logger.info params

    #token = params[:token] + "&e=" + params[:e]
    #video = Video.find_by_token(token)
    #tk = params[:tk]
    #perfil = params[:perfil]
    #resultado = 1
    #xml = Nokogiri::XML(open('http://ws.conecte.us/index.asp?id=' + perfil + '&acao=auth_mp4&token=' + URI::encode(tk)))
    #itens = xml.search('status').map do |item|
    #  resultado = item.text
    #end

    #Rails.logger.info "Resultado da consulta"
    #if !video.status && !(resultado == '1')
    #  video.status = true
    #  video.save
  #    respond_to do |format|
  #      #format.mp4 { send_file File.join(["/mnt/Vids", params[:caminho1], params[:caminho2] + ".mp4"]), :type => 'video/mp4', :disposition => :inline, :stream => true, :buffer_size  =>  4096 }
  #      format.mp4 { send_file File.join(["/mnt/Vids", params[:caminho1], params[:caminho2] + ".mp4"]), :type => 'video/mp4', :buffer_size  =>  1024 }
  #      #format.mp4 { send_file File.join(["/mnt/Vids/3000/1000.mp4"]), :type => 'video/mp4', :buffer_size  =>  1024 }
  #    end
    #else
    #    render(:file => "#{Rails.root}/public/403.html", :status => 403, :layout => false)
    #end

  #end

end
