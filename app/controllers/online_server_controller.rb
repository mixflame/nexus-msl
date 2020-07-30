
class OnlineServerController < ApplicationController

  def online
    my_ip = request.ip #request.env['REMOTE_HOST']
    # require 'net/http'
    # is_up = Net::HTTP.get_response(URI.parse("http://globalchat2.net/main/check_server?host=#{params[:host]}&port=#{params[:port]}")).body == "200"
    if params[:host] != 'localhost'      
      OnlineServer.set_online(params[:name], my_ip, params[:port])
      render :text => "Listed on Nexus"
    else
      render :text => "Not listed", :status => 404
    end
  end

  def offline
    my_ip = request.ip
    OnlineServer.set_offline(my_ip)
    render :nothing => true
  end

  def msl
    render :text => OnlineServer.msl
  end

end
