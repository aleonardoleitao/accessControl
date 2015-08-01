require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do
    it "returns http success when user is signed" do
      sign_in create(:user)
      get 'index'
      response.should be_success
    end

    it "returns http success when user is not signed" do
      get 'index'
      response.should redirect_to(new_user_session_url)
    end
  end

end
