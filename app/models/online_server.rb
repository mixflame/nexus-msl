class OnlineServer < ActiveRecord::Base
  attr_accessible :ip, :name, :port, :url, :host
  validates_uniqueness_of :name
  # validates_uniqueness_of :ip

  def self.set_online(name, ip, port, host)
    server = OnlineServer.find_or_create_by_name(name)
    server.update_attributes(:name => name, :port => port, :host => host, :ip => ip)
  end

  # off GCNet only
  # deprecated.. not called by ServDrop
  def self.set_offline(ip)
    OnlineServer.destroy_all(["online_servers.ip = ?", ip])
  end

  # on GCNet only
  # insecure.. outside clients cant be trusted with this method
  # unless whitelisted
  def self.set_offline_by_name(name)
    OnlineServer.destroy_all(["online_servers.name = ?", name])
  end

  def self.msl
    OnlineServer.all.collect { |s| [s.name, s.host, s.port].join("-!!!-") }.join("\n")
  end

end
