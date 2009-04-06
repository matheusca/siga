require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ServicesController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "services", :action => "index").should == "/services"
    end
  
    it "maps #new" do
      route_for(:controller => "services", :action => "new").should == "/services/new"
    end
  
    it "maps #show" do
      route_for(:controller => "services", :action => "show", :id => "1").should == "/services/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "services", :action => "edit", :id => "1").should == "/services/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "services", :action => "create").should == {:path => "/services", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "services", :action => "update", :id => "1").should == {:path =>"/services/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "services", :action => "destroy", :id => "1").should == {:path =>"/services/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/services").should == {:controller => "services", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/services/new").should == {:controller => "services", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/services").should == {:controller => "services", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/services/1").should == {:controller => "services", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/services/1/edit").should == {:controller => "services", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/services/1").should == {:controller => "services", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/services/1").should == {:controller => "services", :action => "destroy", :id => "1"}
    end
  end
end
