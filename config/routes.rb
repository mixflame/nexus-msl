Nexus::Application.routes.draw do
  get "/online" => "online_server#online"
  get "/offline" => "online_server#offline"
  get "/offline_by_name" => "online_server#offline_by_name"
  get "/msl" => "online_server#msl"
end
