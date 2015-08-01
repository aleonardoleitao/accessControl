require 'spec_helper'

# Using HomeController as implementation of "abstract" ApplicationController
describe HomeController do

  describe 'before_filter' do

    describe 'set_locale' do

      context 'signed in' do
        let(:user) { create(:user, language: 'de') }
        before { sign_in user }

        it 'sets locale based on signed in user language' do
          get :index
          I18n.locale.should == :de
        end

        it 'sets locale based on "l" param' do
          get :index, l: 'ru'
          I18n.locale.should == :ru
        end
      end

      context 'signed out' do
        it 'sets locale with default locale' do
          get :index
          I18n.locale.should == :en
        end

        it 'sets locale based on "l" param' do
          get :index, l: 'es'
          I18n.locale.should == :es
        end

        it 'sets first user language available in the system' do
          request.env['HTTP_ACCEPT_LANGUAGE'] = "ru,pt-br;q=0.7,en-us;q=0.3"
          get :index
          I18n.locale.should == :pt
        end
      end

    end

  end

end
