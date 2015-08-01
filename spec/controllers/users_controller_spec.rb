require 'spec_helper'

describe UsersController do

  let (:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      get :show, id: user.to_param
      assigns(:user).should eq(user)
    end
  end

end
