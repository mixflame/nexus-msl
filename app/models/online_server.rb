class OnlineServer < ActiveRecord::Base
  attr_accessible :ip, :name, :port, :url, :host
  validates_uniqueness_of :name
  validates_uniqueness_of :ip

  def self.set_online(name, ip, port, host)
    server = OnlineServer.find_or_create_by_ip(ip)
  	server.update_attributes(:name => name, :port => port, :host => host)
  end

  def self.set_offline(ip)
  	OnlineServer.destroy_all(["online_servers.ip = ?", ip])
  end

  def self.msl
  	OnlineServer.all.collect { |s| [s.name, s.host, s.port].join("-!!!-") }.join("\n")
  end

end
