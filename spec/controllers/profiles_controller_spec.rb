require 'spec_helper'

describe ProfilesController do

  let(:user) { create(:user) }
  let(:valid_attributes) { { name: "Name" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProfilesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before { sign_in user }

  describe "GET show" do
    it "assigns the requested profile as @profile" do
      get :show, id: user.profile.to_param
      assigns(:profile).should eq(user.profile)
    end
  end

  describe "GET edit" do
    it "assigns the requested profile as @profile" do
      get :edit, {:id => user.profile.to_param}
      assigns(:profile).should eq(user.profile)
    end
  end

  describe "PUT update" do
    let(:valid_attributes) { { name: "New name", avatar: "avatar" } }

    describe "with valid params" do
      before { Profile.any_instance.should_receive(:update_attributes).and_return(true) }

      it "updates the requested profile" do
        put :update, id: user.profile.to_param, profile: valid_attributes
      end

      it "assigns the requested profile as @profile" do
        put :update, id: user.profile.to_param, profile: valid_attributes
        assigns(:profile).should eq(user.profile)
      end

      it "redirects to the profile" do
        put :update, id: user.profile.to_param, profile: valid_attributes
        response.should redirect_to(user.profile)
      end
    end

    describe "with invalid params" do
      it "assigns the requested profile as @profile" do
        put :update, id: user.profile.to_param, profile: { name: "" }
        assigns(:profile).should eq(user.profile)
      end

      it "re-renders the 'edit' template" do
        put :update, id: user.profile.to_param, profile: { name: "" }
        response.should render_template("edit")
      end
    end
  end

end
