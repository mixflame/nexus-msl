require 'spec_helper'

describe OnlineServer do

  before do
    @ip = "127.0.0.1"
    @name = "Jonathan Loopback Funhost"
    @port = 31337
  end


  it 'should be able to set any IP online' do
    OnlineServer.set_online(@name, @ip, @port)
    OnlineServer.find_by_name(@name).nil?.should == false
  end

  it 'can set any IP offline' do
  	OnlineServer.set_online(@name, @ip, @port) # must be online first
    OnlineServer.set_offline(@ip)
    OnlineServer.find_by_name(@name).nil?.should == true
  end

end
