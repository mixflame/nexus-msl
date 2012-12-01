namespace :nexus do

  task :clean => :environment do

    servers = OnlineServer.all

    servers.each do |s|
      is_up = Net::HTTP.get_response(URI.parse("http://globalchat2.net/main/check_server?host=#{s.host}&port=#{s.port}")).body == "200"
      Rails.logger.info "#{s.inspect} up:#{is_up}"
      unless is_up
        s.destroy
      end
    end

  end

end