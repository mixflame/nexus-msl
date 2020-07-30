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

  def self.msl
    OnlineServer.all.collect { |s| 

      unless Rails.env.test?
        require 'socket'
        begin
          s = TCPSocket.new s.ip, s.port
          s.close
          if !s.name.blank? && !s.ip.blank? && !s.port.blank? 
            ["SERVER", s.name, s.ip, s.port ].join("::!!::") 
          end
        rescue
          nil
        end
      else
        if !s.name.blank? && !s.ip.blank? && !s.port.blank? 
          ["SERVER", s.name, s.ip, s.port ].join("::!!::") 
        end
      end


  }.join("\n")
  end

end
