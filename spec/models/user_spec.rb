require 'spec_helper'

describe User do

  describe "default values" do
    let (:user) { User.new }
    it { user.status.should == 'active' }
    it { user.kind.should == 'visitor' }
  end

  describe "after create" do
    let(:user) { create(:user) }

    it "creates the profile" do
      user.profile.should be_a_kind_of(Profile)
    end

    it "persists the profile" do
      user.profile.should be_persisted
    end
  end

  describe ".find_first_by_auth_conditions" do
    let (:user) { create(:user) }

    it "returns the user using username as login" do
      response = User.find_first_by_auth_conditions(login: user.username)
      response.should == user
    end

    it "returns the user using email as login" do
      response = User.find_first_by_auth_conditions(login: user.email)
      response.should == user
    end

    it "returns the user without login" do
      response = User.find_first_by_auth_conditions(id: user.id)
      response.should == user
    end
  end

end
