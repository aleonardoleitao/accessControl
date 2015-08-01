require 'spec_helper'

describe Profile do

  describe "uniqueness by user" do
    let(:user) { create(:user) } # user has a profile empty

    it "raises error if user has two profiles" do
      profile = Profile.new
      profile.user = user
      profile.should_not be_valid
      profile.errors_on(:user_id).should include("has already been taken")
    end
  end

  describe "#follow!" do
    let(:profile) { create(:user).profile }
    let(:friend) { create(:user).profile }

    it "fails silenty if user try to follow a friend twice" do
      profile.follow! friend
      profile.follow! friend

      profile.following.count.should == 1
    end

    it "raises error if user try to follow himself" do
      expect { profile.follow! profile }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Following can't be the Follower")
    end

    it "increments the following cache counter to follower on add" do
      expect { profile.follow! friend }.to change { profile.reload.following_count }.by(1)
    end

    it "doesn't increments the followers cache counter to follower on add" do
      expect { profile.follow! friend }.to change { profile.reload.followers_count }.by(0)
    end

    it "increments the followers cache counter to following on add" do
      expect { profile.follow! friend }.to change { friend.reload.followers_count }.by(1)
    end

    it "doesn't increments the following cache counter to following on add" do
      expect { profile.follow! friend }.to change { friend.reload.following_count }.by(0)
    end

    it "decrements the following cache counter on remove" do
      profile.follow! friend
      expect { profile.unfollow! friend }.to change { profile.reload.following_count }.by(-1)
    end

    it "decrements the followers cache counter on remove" do
      profile.follow! friend
      expect { profile.unfollow! friend }.to change { friend.reload.followers_count }.by(-1)
    end

    it "should set correct follower to favorite object" do
      profile.follow! friend
      favorite = profile.following_favorites.first
      favorite.follower.should == profile
    end

    it "should set correct following to favorite object" do
      profile.follow! friend
      favorite = profile.following_favorites.first
      favorite.following.should == friend
    end
  end

  describe "#display_name" do
    let(:user) { create(:user) }

    it "shows username when profile.name is nil" do
      user.profile.name = nil
      user.profile.display_name.should == user.username
    end

    it "shows username when profile.name is empty" do
      user.profile.name = ""
      user.profile.display_name.should == user.username
    end

    it "shows name when profile.name is not empty" do
      name = Faker::Name.name
      user.profile.name = name
      user.profile.display_name.should == name
    end
  end

  describe "#visit_increment!" do
    let(:user) { create(:user) }
    before { user.profile.visit_increment! }

    it "increment visit count attribute from zero to one" do
      user.profile.visits_count.should == 1
    end

    it "increment visit count attribute twice" do
      user.profile.visit_increment!
      user.profile.visits_count.should == 2
    end
  end

end
