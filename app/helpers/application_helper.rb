module ApplicationHelper

  def get_secure_path_uri(uri, expires=600)
    path = URI.parse(uri).path
    exp = Time.now.to_i + expires
    seed = "0p3nCRS#{path}#{exp}"
    hash = Digest::SHA1.base64digest(seed).tr('+/', '-_').gsub('=','')
    "#{path}?st=#{hash}&e=#{exp}"
  end

  def get_secure_path(uri, expires=600)
    path = uri
    exp = Time.now.to_i + expires
    seed = "0p3nCRS#{path}#{exp}"
    hash = Digest::SHA1.base64digest(seed).tr('+/', '-_').gsub('=','')
    "#{path}?st=#{hash}&e=#{exp}"
  end

  def get_secure_token(uri, expires=600)
    path = uri
    exp = Time.now.to_i + expires
    seed = "0cc3ssC4ntr4l#{path}#{exp}"
    hash = Digest::SHA1.base64digest(seed).tr('+/', '-_').gsub('=','')
    "#{hash}&e=#{exp}"
  end

  # TODO: test!
  # ts == translate scoped
  def ts(key, scope = nil)
    invoked_by = Kernel.caller.first
    I18n.translate key, scope: [scope_from_file_path(invoked_by), scope].compact.join('.')
  end

  def scope_from_file_path(file_path)
    file_path.match(/app\/([^.]+)/)[1].gsub(/\/_?/,'.')
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  # É igual ao helper simple_format do Rails.
  # Alterado apenas para criar uma <div> em vez de criar um <p>
  # e tem um nome mais curto
  def f(text, html_options={}, options={})
    text = '' if text.nil?
    text = text.dup
    start_tag = tag('div', html_options, true)
    text = sanitize(text) unless options[:sanitize] == false
    text = text.to_str
    text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
    text.gsub!(/\n\n+/, "</div>\n\n#{start_tag}")  # 2+ newline  -> paragraph
    text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
    text.insert 0, start_tag
    text.html_safe.safe_concat("</div>")
  end

  # Faz um sanitize do texto passado.
  # Se um profile válido for passado em options[:from] e esse profile for o current_profile:
  #   - não remove as forbidden words
  # Em todos os outros casos:
  #   - remove as forbidden words
  def clear(string, options = {})
    profile = options[:from]
    skip_blacklist = profile == current_profile
    string = ForbiddenWord.sanitize(string) unless skip_blacklist
    sanitize string
  end
end
