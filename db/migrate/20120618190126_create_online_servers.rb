class CreateOnlineServers < ActiveRecord::Migration
  def change
    create_table :online_servers do |t|
      t.string :name
      t.string :ip
      t.integer :port
      t.string :url

      t.timestamps
    end
  end
end
