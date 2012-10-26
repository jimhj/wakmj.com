# coding: utf-8
require 'spec_helper'

describe User do
  user = FactoryGirl.create(:user)
  user2 = FactoryGirl.create(:superadmin)
  tv_drama = FactoryGirl.create(:tv_drama)

  describe "roles:" do
    # subject { user }

    context "when is a new user" do
      it { user.should have_role('member') }
    end

    context "when is superadmin" do
      it { user2.should have_role('superadmin') }
    end

  end

  describe 'like:' do
    it "can like tv_drama" do
      user.like(tv_drama)
      tv_drama.reload
      tv_drama.likes_count.should == 3
      tv_drama.liked_user_ids.should include(user.id)

      user2.like(tv_drama)
      tv_drama.reload
      tv_drama.likes_count.should == 2
      tv_drama.liked_user_ids.should include(user2.id)      
    end

    # it "can unlike tv_drama" do
    #   user2.unlike(tv_drama)
    #   tv_drama.likes_count.should eq(1)
    #   tv_drama.liked_user_ids.should include(user.id)
    #   tv_drama.liked_user_ids.should_not include(user2.id)
    # end
  end



end
