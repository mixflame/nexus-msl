require 'spec_helper'

describe OnlineServerController do

	before :each do
		get 'online', :name => 'jsilver server', :port => 1337
	end

  describe "GET 'online'" do
    it 'should allow setting request IP online with any port and name' do
      #get 'online', :name => 'jsilver server', :port => 1337
      response.should be_success
    end
  end

  describe "GET 'offline'" do
    it 'should allow setting request IP offline' do
    	#get 'online', :name => 'jsilver server', :port => 1337 #dbcleaner, beonline
    	get 'offline'
    	response.should be_success
    end
  end

  describe "GET 'msl'" do
    it 'should return a text list of name:ip:port' do
    	#get 'online', :name => 'jsilver server', :port => 1337
    	get 'msl'
    	response.should be_success
    	response.body.should == "jsilver server:0.0.0.0:1337"
    end
  end


end
