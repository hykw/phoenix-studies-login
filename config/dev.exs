use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :login_study, LoginStudy.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: []

# Watch static and templates for browser reloading.
config :login_study, LoginStudy.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n", level: :debug

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :login_study, LoginStudy.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "testuser",
  password: "testpass",
  database: "phoenix_studies_login",
  hostname: "localhost",
  pool_size: 10

import_config "secrets/#{Mix.env}.secrets.exs"

# Überauth
config :ueberauth, Ueberauth,
providers: [
  facebook: {Ueberauth.Strategy.Facebook, [
      profile_fields: "name,email",
      request_path: "/social_login/facebook",
      callback_path: "/social_login/facebook_callback/"
    ]},
  twitter: {Ueberauth.Strategy.Twitter, [
      request_path: "/social_login/twitter",
      callback_path: "/social_login/twitter_callback/"
    ]}

]


# Plug.Session.MEMCACHED
config :plug_session_memcached,
  server: [ '127.0.0.1', 11211 ]


