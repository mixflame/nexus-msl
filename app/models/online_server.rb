class OnlineServer < ActiveRecord::Base
  attr_accessible :ip, :name, :port
  validates_uniqueness_of :name
  validates_uniqueness_of :ip

  def self.set_online(name, ip, port)
  	OnlineServer.create(:name => name, :ip => ip, :port => port)
  end

  def self.set_offline(ip)
  	OnlineServer.find_by_ip(ip).destroy
  end

  def self.msl
  	OnlineServer.all.collect { |s| [s.name, s.ip, s.port].join(":") }.join("\n")
  end

end
