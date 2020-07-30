require 'net/ping'

class OnlineServer < ActiveRecord::Base
  attr_accessible :ip, :name, :port, :url, :host
  validates_uniqueness_of :name
  # validates_uniqueness_of :ip

  def self.set_online(name, ip, port)
    OnlineServer.where(ip: ip).destroy_all
    server = OnlineServer.find_or_create_by(ip: ip)
    server.update_attributes(:name => name, :port => port, :ip => ip)
  end

  def self.set_offline(ip)
    OnlineServer.destroy_all(["online_servers.ip = ?", ip])
  end

  def self.port_open?(ip, port, seconds=1)
    require 'socket'
    require 'timeout'
    # => checks if a port is open or not on a remote host
    Timeout::timeout(seconds) do
      begin
        TCPSocket.new(ip, port).close
        true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
        false
      end
    end
    rescue Timeout::Error
      false
  end

  def self.msl
    require 'socket'
    out = []
    OnlineServer.all.each { |s| 

          check = Net::Ping::External.new(host)
          if !s.name.blank? && !s.ip.blank? && !s.port.blank? && check.ping? && self.port_open?(s.ip, s.port)
            out << ["SERVER", s.name, s.ip, s.port ].join("::!!::") 
          end

  }
  
  
  out.join("\n")
  end

end
