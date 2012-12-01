Nexus::Application.routes.draw do
  match "/online" => "online_server#online"
  match "/offline" => "online_server#offline"
  match "/offline_by_name" => "online_server#offline_by_name"
  match "/msl" => "online_server#msl"

  match "/ipn" => "paypal#paypal_ipn"
end
