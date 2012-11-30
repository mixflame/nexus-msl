Nexus::Application.routes.draw do
  match "/online" => "online_server#online"
  match "/offline" => "online_server#offline"
  match "/msl" => "online_server#msl"

  match "/ipn" => "paypal#paypal_ipn"
end
