class OnlineServer < ActiveRecord::Base
  attr_accessible :ip, :name, :port, :url
  validates_uniqueness_of :name
  validates_uniqueness_of :ip

  def self.set_online(name, ip, port, url)
  	OnlineServer.create(:name => name, :ip => ip, :port => port, :url => url)
  end

  def self.set_offline(ip)
  	OnlineServer.destroy_all(["online_servers.ip = ?", ip])
  end

  def self.msl
  	OnlineServer.all.collect { |s| [s.name, s.ip, s.port, s.url].join("-!!!-") }.join("\n")
  end

end
