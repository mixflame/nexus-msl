require 'spec_helper'

describe OnlineServer do

  before do
    @ip = "127.0.0.1"
    @name = "jsilver"
    @port = 31337
    @url = "http://jsilver.com"
    OnlineServer.set_online(@name, @ip, @port, @url)
  end


  it 'should be able to set any IP online' do
    
    OnlineServer.find_by_name(@name).nil?.should == false
  end

  it 'can set any IP offline' do
    OnlineServer.set_offline(@ip)
    OnlineServer.find_by_name(@name).nil?.should == true
  end

  it 'can return the MSL' do
    msl = OnlineServer.msl
    msl.should == "jsilver-!!!-127.0.0.1-!!!-31337-!!!-http://jsilver.com"
  end

end
