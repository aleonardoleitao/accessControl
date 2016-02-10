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

  def gera_video_streaming
    require 'openssl'
    require 'digest/sha1'

    user_agent = request.env['HTTP_USER_AGENT']

    Rails.logger.info " request - #{request} "

    Rails.logger.info " User Agent - #{user_agent} "
    Rails.logger.info " Token Video - #{params[:tokenvideo]} "
    token_video = params[:tokenvideo]
    video = params[:video]

    iv = Base64.decode64("kT+uMuPwUk2LH4cFbK0GiA==")
    key = ["6476b3f5ec6dcaddb637e9c9654aa687"].pack("H*")

    decipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
    decipher.decrypt
    decipher.key = key
    decipher.iv = iv
    text = decipher.update(Base64.strict_decode64(token_video)) 
    text << decipher.final

    puts "encrypted: #{text}\n"
    #encrypted_text = Base64.strict_encode64(text)
    indice = ["", ""]
    if text
      begin
        indice = text.split("|")
        token_video = indice[0]
        tamanho = Integer(indice[1])
      rescue
        token_video = ""
        tamanho = 0
      end
    end

    #debugger
    #Verifica a plataforma
    if token_video.to_s.downcase != "" and token_video.to_s.downcase != "unknown"
      navegador_habilitado = Regexp.new("macintel|macintosh|macppc|mac68k|win32|win64").match(token_video.to_s.downcase)
    end

    #Verifica se e webview
    if !navegador_habilitado
      navegador_habilitado = Regexp.new("wv").match(user_agent.to_s.downcase)
    end

    if !navegador_habilitado && tamanho > 1023
      navegador_habilitado = true
    end

    Rails.logger.info " Token Video - #{navegador_habilitado} "

    if !navegador_habilitado
      tokenGerado = get_secure_token(params[:caminho]).to_s
      @video = Video.new({path: params[:caminho],status:false,token:tokenGerado})
      @video.save
      respond_to do |format|
        format.json { render json: { path: params[:caminho], token: tokenGerado }}
      end
    else
      respond_to do |format|
        format.json { render json: { path: "", token: "" }}
      end
    end
  end

  # def exibe_video

  #   user_agent = request.env['HTTP_USER_AGENT']
  #   chrome, safari, firefox = false
  #   diretorio = "/mnt/Vids"

  #   Rails.logger.info "UserAgente - #{user_agent}"
  #   if user_agent =~ /Chrome/
  #     chrome = true
  #     Rails.logger.info "Browser Chrome"
  #   end
  #   if user_agent =~ /QuickTime/
  #     safari = true
  #     Rails.logger.info "Browser QuickTime"
  #   end
  #   if user_agent =~ /Firefox/
  #     firefox = true
  #     Rails.logger.info "Browser Firefox"
  #   end

  #   file_name = params[:caminho2] + ".mp4"
  #   if file_name == "4125945F1D0BE26B4474C897026704D1B88E621082015073455" || file_name == "41259E2B5E7A778474B62AA8464709CBA962B20082015120530" || file_name == "412595829D51A8AC549F8B3FB7E67C41238F217082015163546"
  #     diretorio = "/opt/railsapps/videos"
  #   end
  #   file_path = File.join([diretorio, params[:caminho1], params[:caminho2] + ".mp4"])
    

  #   Rails.logger.info "Iniciando a consulta no exibe video com os parametros - #{params}"

  #   token = params[:token] + "&e=" + params[:e]
  #   video = Video.find_by_token(token)
  #   tk = params[:tk]
  #   perfil = params[:perfil]
  #   resultado = 1

  #   xml = Nokogiri::XML(open('http://ws.conecte.us/index.asp?id=' + perfil + '&acao=auth_mp4&token=' + URI::encode(tk)))
  #   itens = xml.search('status').map do |item|
  #     resultado = item.text
  #   end

  #   Rails.logger.info "Resultado da consulta - webserver - #{resultado}"
  #   Rails.logger.info "Resultado da consulta - video token - #{video.status}"

  #   mobile_android =  "palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|mobile|zune"
  #   mobile_iphone =  "ipod|ipad|iphone"
  #   mobile_windowsce = "windows ce"

  #   mobile_android = Regexp.new(mobile_android).match(user_agent.to_s.downcase)
  #   mobile_iphone = Regexp.new(mobile_iphone).match(user_agent.to_s.downcase)
  #   mobile_windowsce = Regexp.new(mobile_windowsce).match(user_agent.to_s.downcase)

  #   if mobile_android == nil 
  #     mobile_android = 0 
  #   end
  #   if mobile_iphone == nil 
  #     mobile_iphone = 0 
  #   end
  #   if mobile_windowsce == nil 
  #     mobile_windowsce = 0 
  #   end

  #   Rails.logger.info ("Android - #{mobile_android}")
  #   Rails.logger.info ("IOs - #{mobile_iphone}")
  #   Rails.logger.info ("Windows CE - #{mobile_windowsce}")

  #   if !(resultado == '1') && ((mobile_android!=0 || mobile_iphone!=0 || mobile_windowsce!=0) || (!video.status))

  #     video.status = true
  #     video.save

  #     Rails.logger.info "Exbindo o video"

  #     if (mobile_iphone!=0) || ((request.headers["HTTP_RANGE"]) && !chrome && !firefox && !(mobile_android != 0))

  #       size = File.size(file_path)
  #       bytes = Rack::Utils.byte_ranges(request.headers, size)[0]
  #       offset = bytes.begin
  #       length = bytes.end - bytes.begin + 1

  #       response.header["Accept-Ranges"]=  "bytes"
  #       response.header["Content-Range"] = "bytes #{bytes.begin}-#{bytes.end}/#{size}"

  #       Rails.logger.info "bytes #{bytes.begin}-#{bytes.end}/#{size}"
  #       Rails.logger.info "Iniciando o envio IOS"
  #       send_data IO.binread(file_path,length, offset), :type => "video/mp4", :stream => true, :x_sendfile => true, :disposition => 'inline', :file_name => file_name, :buffer_size  =>  2048
  #       Rails.logger.info "Arquivo enviado IOS"

  #     else
  #       Rails.logger.info "Exibindo videos apenas para o chrome"
  #       Rails.logger.info file_path
  #       respond_to do |format|
  #         format.mp4 { send_file(file_path, :disposition => 'attachment', :file_name => file_name, :x_sendfile => true, :type => 'video/mp4')}
  #       end
  #       Rails.logger.info "Finalizando videos do chrome"
  #     end

  #   else
  #     render(:file => "#{Rails.root}/public/403.html", :status => 403, :layout => false)
  #   end
  # end

  def exibe_video

    user_agent = request.env['HTTP_USER_AGENT']
    chrome, safari, firefox = false
    diretorio = "/mnt/Vids"

    #Rails.logger.info "UserAgente - #{user_agent}"
    if user_agent =~ /Chrome/
      chrome = true
      #Rails.logger.info "Browser Chrome"
    end
    if user_agent =~ /QuickTime/
      safari = true
      #Rails.logger.info "Browser QuickTime"
    end
    if user_agent =~ /Firefox/
      firefox = true
      #Rails.logger.info "Browser Firefox"
    end

    file_name = params[:caminho2] + ".mp4"
    if file_name == "4125945F1D0BE26B4474C897026704D1B88E621082015073455" || file_name == "41259E2B5E7A778474B62AA8464709CBA962B20082015120530" || file_name == "412595829D51A8AC549F8B3FB7E67C41238F217082015163546"
      diretorio = "/opt/railsapps/videos"
    end
    file_path = File.join([diretorio, params[:caminho1], params[:caminho2] + ".mp4"])
    

    #Rails.logger.info "Iniciando a consulta no exibe video com os parametros - #{params}"

    token = params[:token] + "&e=" + params[:e]
    video = Video.find_by_token(token)
    tk = params[:tk]
    perfil = params[:perfil]
    resultado = 0
    acessoDuplicado = 0 #inicia o acesso duplicado com false
    range = request.headers['HTTP_RANGE']
    url = request.url.gsub('http:', 'https:')
    validUrl = url.eql? request.headers['HTTP_REFERER']

    #Rails.logger.info ("URL #{url} - #{request.headers['HTTP_REFERER']} ")

    if video.time
      #Verifica se o usuario acessou essa mesma url 2 vezes
      acessoDuplicado = ((video.time+4)>=Time.now)
      #Rails.logger.info "Video.time: #{video.time} Time.now: #{Time.now} - acessoDuplicado: #{acessoDuplicado}"      
    end

    #debugger
    xml = Nokogiri::XML(open('http://ws.conecte.us/index.asp?id=' + perfil + '&acao=auth_mp4&token=' + URI::encode(tk)))
    itens = xml.search('status').map do |item|
     resultado = item.text
     Rails.logger.info ("Resultado da consulta: #{resultado}")
    end

    #Rails.logger.info "Resultado da consulta - webserver - #{resultado}"
    #Rails.logger.info "Resultado da consulta - video token - #{video.status}"

    mobile_android =  "palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|mobile|zune"
    mobile_iphone =  "ipod|ipad|iphone"
    mobile_windowsce = "windows ce|wmfsdk|edge"

    mobile_android = Regexp.new(mobile_android).match(user_agent.to_s.downcase)
    mobile_iphone = Regexp.new(mobile_iphone).match(user_agent.to_s.downcase)
    mobile_windowsce = Regexp.new(mobile_windowsce).match(user_agent.to_s.downcase)

    if mobile_android == nil 
      mobile_android = 0 
    end
    if mobile_iphone == nil 
      mobile_iphone = 0 
    end
    if mobile_windowsce == nil 
      mobile_windowsce = 0 
    end

    # Rails.logger.info ("UserAgente - #{user_agent} ")
    # Rails.logger.info ("Android - #{mobile_android}")
    # Rails.logger.info ("IOs - #{mobile_iphone}")
    # Rails.logger.info ("Windows CE - #{mobile_windowsce}")
    # Rails.logger.info ("Range - #{request.headers['HTTP_RANGE']} ")
    # Rails.logger.info ("Range - #{range} ")
    # Rails.logger.info ("Range - #{acessoDuplicado && video.range != range} ")

    if !validUrl && (resultado && (acessoDuplicado || request.headers['HTTP_RANGE']))
    #if resultado && (!acessoDuplicado || range) && (!acessoDuplicado || video.range != range)

      if !video.status
        video.status = true
        video.time = Time.now
      #  video.range = range
        video.save
      #elsif video.range != range
      #  video.range = range
      #  video.save
      end        

      #Rails.logger.info "Exbindo o video - streaming"

      if (mobile_iphone!=0) || ((request.headers["HTTP_RANGE"]) && !chrome && !firefox && !(mobile_android != 0 || mobile_windowsce != 0))

        size = File.size(file_path)
        bytes = Rack::Utils.byte_ranges(request.headers, size)[0]
        offset = bytes.begin
        length = bytes.end - bytes.begin + 1

        response.header["Accept-Ranges"]=  "bytes"
        response.header["Content-Range"] = "bytes #{bytes.begin}-#{bytes.end}/#{size}"

        #Rails.logger.info "bytes #{bytes.begin}-#{bytes.end}/#{size}"
        #Rails.logger.info "Iniciando o envio IOS"
        send_data IO.binread(file_path,length, offset), :type => "video/mp4", :stream => true, :x_sendfile => true, :disposition => 'inline', :file_name => file_name, :buffer_size  =>  2048
        #Rails.logger.info "Arquivo enviado IOS"

      else
        #Rails.logger.info "Exibindo videos apenas para o chrome e firefox"
        #Rails.logger.info file_path
        respond_to do |format|
          format.mp4 { send_file(file_path, :disposition => 'inline', :stream => true, :file_name => file_name, :type => 'video/mp4')}
        end
        #Rails.logger.info "Finalizando videos do chrome"
      end

    else
      render(:file => "#{Rails.root}/public/403.html", :status => 403, :layout => false)
    end

  end

  def exibe_video_streaming

    user_agent = request.env['HTTP_USER_AGENT']
    chrome, safari, firefox = false
    diretorio = "/mnt/Vids"

    Rails.logger.info "UserAgente - #{user_agent}"
    if user_agent =~ /Chrome/
      chrome = true
      Rails.logger.info "Browser Chrome"
    end
    if user_agent =~ /QuickTime/
      safari = true
      Rails.logger.info "Browser QuickTime"
    end
    if user_agent =~ /Firefox/
      firefox = true
      Rails.logger.info "Browser Firefox"
    end

    file_name = params[:caminho2] + ".mp4"
    if file_name == "4125945F1D0BE26B4474C897026704D1B88E621082015073455" || file_name == "41259E2B5E7A778474B62AA8464709CBA962B20082015120530" || file_name == "412595829D51A8AC549F8B3FB7E67C41238F217082015163546"
      diretorio = "/opt/railsapps/videos"
    end
    file_path = File.join([diretorio, params[:caminho1], params[:caminho2] + ".mp4"])
    

    Rails.logger.info "Iniciando a consulta no exibe video com os parametros - #{params}"

    token = params[:token] + "&e=" + params[:e]
    video = Video.find_by_token(token)
    tk = params[:tk]
    perfil = params[:perfil]
    resultado = 0
    acessoDuplicado = 0 #inicia o acesso duplicado com false
    range = request.headers['HTTP_RANGE']
    url = request.url.gsub('http:', 'https:')
    validUrl = url.eql? request.headers['HTTP_REFERER']

    Rails.logger.info ("URL #{url} - #{request.headers['HTTP_REFERER']} ")

    if video.time
      #Verifica se o usuario acessou essa mesma url 2 vezes
      acessoDuplicado = ((video.time+2)>=Time.now)
      Rails.logger.info "Video.time: #{video.time} Time.now: #{Time.now} - acessoDuplicado: #{acessoDuplicado}"      
    end

    xml = Nokogiri::XML(open('http://ws.conecte.us/index.asp?id=' + perfil + '&acao=auth_mp4&token=' + URI::encode(tk)))
    itens = xml.search('status').map do |item|
      resultado = item.text
    end

    Rails.logger.info "Resultado da consulta - webserver - #{resultado}"
    Rails.logger.info "Resultado da consulta - video token - #{video.status}"

    mobile_android =  "palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|mobile|zune"
    mobile_iphone =  "ipod|ipad|iphone"
    mobile_windowsce = "windows ce|wmfsdk|edge|iemobile"

    mobile_android = Regexp.new(mobile_android).match(user_agent.to_s.downcase)
    mobile_iphone = Regexp.new(mobile_iphone).match(user_agent.to_s.downcase)
    mobile_windowsce = Regexp.new(mobile_windowsce).match(user_agent.to_s.downcase)

    if mobile_android == nil 
      mobile_android = 0 
    end
    if mobile_iphone == nil 
      mobile_iphone = 0 
    end
    if mobile_windowsce == nil 
      mobile_windowsce = 0
    end

    Rails.logger.info ("UserAgente - #{user_agent} ")
    Rails.logger.info ("Android - #{mobile_android}")
    Rails.logger.info ("IOs - #{mobile_iphone}")
    Rails.logger.info ("Windows CE - #{mobile_windowsce}")
    Rails.logger.info ("Range - #{request.headers['HTTP_RANGE']} ")
    Rails.logger.info ("Range - #{range} ")
    Rails.logger.info ("Range - #{acessoDuplicado && video.range != range} ")

    #criar uma validacao
    #bytes=0-

    if !validUrl && (resultado && (acessoDuplicado || request.headers['HTTP_RANGE']))
    #if resultado && (!acessoDuplicado || range) && (!acessoDuplicado || video.range != range)

      if !video.status
        video.status = true
        video.time = Time.now
      #  video.range = range
        video.save
      #elsif video.range != range
      #  video.range = range
      #  video.save
      end        

      Rails.logger.info "Exbindo o video - streaming"

      if (mobile_iphone!=0) || ((request.headers["HTTP_RANGE"]) && !chrome && !firefox && !(mobile_android != 0 || mobile_windowsce != 0))

        size = File.size(file_path)
        bytes = Rack::Utils.byte_ranges(request.headers, size)[0]
        offset = bytes.begin
        length = bytes.end - bytes.begin + 1

        response.header["Accept-Ranges"]=  "bytes"
        response.header["Content-Range"] = "bytes #{bytes.begin}-#{bytes.end}/#{size}"

        Rails.logger.info "bytes #{bytes.begin}-#{bytes.end}/#{size}"
        Rails.logger.info "Iniciando o envio IOS"
        send_data IO.binread(file_path,length, offset), :type => "video/mp4", :stream => true, :x_sendfile => true, :disposition => 'inline', :file_name => file_name, :buffer_size  =>  2048
        Rails.logger.info "Arquivo enviado IOS"

      else

        Rails.logger.info "Teste para verificar se e WP - #{mobile_windowsce!=0}"
        if mobile_windowsce!=0 && request.headers["HTTP_RANGE"] == "bytes=0-"
          render(:file => "#{Rails.root}/public/403.html", :status => 403, :layout => false)
        else
          Rails.logger.info "Exibindo videos apenas para WP/Android"
          Rails.logger.info file_path
          respond_to do |format|
            format.mp4 { send_file(file_path, :disposition => 'inline', :stream => true, :file_name => file_name, :type => 'video/mp4')}
          end
          Rails.logger.info "Finalizando videos do chrome"          
        end

      end

    else
      render(:file => "#{Rails.root}/public/403.html", :status => 403, :layout => false)
    end

  end

  def exibe_video_html5

    user_agent = request.env['HTTP_USER_AGENT']
    chrome, safari, firefox = false
    diretorio = "/mnt/Vids"

    Rails.logger.info "UserAgente - #{user_agent}"
    if user_agent =~ /Chrome/
      chrome = true
      Rails.logger.info "Browser Chrome"
    end
    if user_agent =~ /QuickTime/
      safari = true
      Rails.logger.info "Browser QuickTime"
    end
    if user_agent =~ /Firefox/
      firefox = true
      Rails.logger.info "Browser Firefox"
    end

    file_name = params[:caminho2] + ".mp4"
    if file_name == "4125945F1D0BE26B4474C897026704D1B88E621082015073455" || file_name == "41259E2B5E7A778474B62AA8464709CBA962B20082015120530" || file_name == "412595829D51A8AC549F8B3FB7E67C41238F217082015163546"
      diretorio = "/opt/railsapps/videos"
    end
    file_path = File.join([diretorio, params[:caminho1], params[:caminho2] + ".mp4"])
    

    Rails.logger.info "Iniciando a consulta no exibe video com os parametros - #{params}"

    token = params[:token] + "&e=" + params[:e]
    video = Video.find_by_token(token)
    tk = params[:tk]
    perfil = params[:perfil]
    resultado = 1

    #xml = Nokogiri::XML(open('http://ws.conecte.us/index.asp?id=' + perfil + '&acao=auth_mp4&token=' + URI::encode(tk)))
    #itens = xml.search('status').map do |item|
    #  resultado = item.text
    #end

    Rails.logger.info "Resultado da consulta - webserver - #{resultado}"
    Rails.logger.info "Resultado da consulta - video token - #{video.status}"

    #Se safari invalida autenticacao para download
    #if safari==true || (!video.status && !(resultado == '1'))

    mobile_android =  "palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|mobile|zune"
    mobile_iphone =  "ipod|ipad|iphone"
    mobile_windowsce = "windows ce|iemobile"

    mobile_android = Regexp.new(mobile_android).match(user_agent.to_s.downcase)
    mobile_iphone = Regexp.new(mobile_iphone).match(user_agent.to_s.downcase)
    mobile_windowsce = Regexp.new(mobile_windowsce).match(user_agent.to_s.downcase)

    if mobile_android == nil 
      mobile_android = 0 
    end
    if mobile_iphone == nil 
      mobile_iphone = 0 
    end
    if mobile_windowsce == nil 
      mobile_windowsce = 0 
    end

    Rails.logger.info ("Android - #{mobile_android}")
    Rails.logger.info ("IOs - #{mobile_iphone}")
    Rails.logger.info ("Windows CE - #{mobile_windowsce}")
    Rails.logger.info ("Range - #{request.headers['HTTP_RANGE']} ")

    if resultado && ((mobile_android!=0 || mobile_windowsce!=0) || request.headers['HTTP_RANGE'])
    #if !(resultado == '1') && ((mobile_android!=0 || mobile_iphone!=0 || mobile_windowsce!=0) || (!video.status))

      video.status = true
      video.save

      Rails.logger.info "Exbindo o video - streaming"

      if (mobile_iphone!=0) || ((request.headers["HTTP_RANGE"]) && !chrome && !firefox && !(mobile_android != 0))

        size = File.size(file_path)
        bytes = Rack::Utils.byte_ranges(request.headers, size)[0]
        offset = bytes.begin
        length = bytes.end - bytes.begin + 1

        response.header["Accept-Ranges"]=  "bytes"
        response.header["Content-Range"] = "bytes #{bytes.begin}-#{bytes.end}/#{size}"

        Rails.logger.info "bytes #{bytes.begin}-#{bytes.end}/#{size}"
        Rails.logger.info "Iniciando o envio IOS"
        send_data IO.binread(file_path,length, offset), :type => "video/mp4", :stream => true, :x_sendfile => true, :disposition => 'inline', :file_name => file_name, :buffer_size  =>  2048
        Rails.logger.info "Arquivo enviado IOS"

      else
        Rails.logger.info "Exibindo videos apenas para o chrome e firefox"
        Rails.logger.info file_path
        respond_to do |format|
          format.mp4 { send_file(file_path, :disposition => 'inline', :stream => true, :file_name => file_name, :type => 'video/mp4')}
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
