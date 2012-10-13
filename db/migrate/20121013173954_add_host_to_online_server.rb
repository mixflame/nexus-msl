class AddHostToOnlineServer < ActiveRecord::Migration
  def change
    add_column :online_servers, :host, :string 
    OnlineServer.all.each do |s|
      s.update_attribute :host, s.ip
    end
  end
end
