require File.dirname(__FILE__) + '/../spec_helper'
require "cancan/matchers"

describe "Routing shortcuts for Funding Sources (/funding_sources) should map" do
  controller_name :funding_sources
  
  it "funding_sources_data_entry to /funding_sources" do
    funding_sources_data_entry_path.should == '/funding_sources'
  end
  
end


describe FundingSourcesController do
  context "as visitor" do
    context "get index" do
      before :each do get :index end
      it { should redirect_to(login_path) }
      it { should set_the_flash.to("You must be signed in to do that") }
    end
  end

  context "as reporter" do
    before :each do
      @user = Factory.create(:reporter)
      login @user
    end
    
    context "get index" do
      before :each do
        get :index
      end
      # pending http://www.pivotaltracker.com/story/show/4944177
      #it { should render_template(:index) }
      #it { should_not set_the_flash }
    end
    
  end
end