class ApplicationController < ActionController::Base
  include ApplicationHelper

  before_filter :set_locale
  respond_to :html

  def current_profile
    current_user.profile if user_signed_in?
  end

  private

    def set_locale
      return I18n.locale = 'pt'
    end

    def locales_from_accept_language_header
      # Copied from http_accept_language gem
      # https://github.com/iain/http_accept_language/blob/master/lib/http_accept_language/parser.rb
      request.env['HTTP_ACCEPT_LANGUAGE'].gsub(/\s+/, '').split(/,/).collect do |l|
        l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
        l.split(';q=')
      end.sort do |x,y|
        raise "Not correctly formatted" unless x.first =~ /^[a-z\-0-9]+$/i
        y.last.to_f <=> x.last.to_f
      end.collect do |l|
        # l.first.downcase.gsub(/-[a-z0-9]+$/i) { |x| x.upcase } # original line
        l.first.downcase.gsub(/-[a-z0-9]+$/i, '').to_sym # I need remove -XX from locale
      end
    rescue # Just rescue anything if the browser messed up badly.
      []
    end

    def user_languages
      @user_locales = locales_from_accept_language_header
      unavailable_locales = @user_locales - I18n.available_locales
      @user_locales - unavailable_locales
    end
end
