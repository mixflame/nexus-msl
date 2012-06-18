Nexus::Application.routes.draw do
  match "/online/:name/:port" => "online_server#online"
  match "/offline" => "online_server#offline"
  match "/msl" => "online_server#msl"
end
