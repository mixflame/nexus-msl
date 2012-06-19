
class OnlineServerController < ApplicationController

  def online
    my_ip = request.ip
    server = OnlineServer.set_online(params[:name], my_ip, params[:port], params[:url])
    render :nothing => true
  end

  def offline
    my_ip = request.ip
    server = OnlineServer.set_offline(my_ip)
    render :nothing => true
  end

  def msl
  	render :text => OnlineServer.msl
  end

end
