use Mix.Config

config :login_study, Social_Login,
  facebook_private_key: "facebook_private_keyの値"



config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "xxxxxxxxxxxx",
  client_secret: "yyyyyyyyyyyy"

config :ueberauth, Ueberauth.Strategy.Twitter.OAuth,
  consumer_key: "xxxxxxxxxxxx",
  consumer_secret: "yyyyyyyyyy"
