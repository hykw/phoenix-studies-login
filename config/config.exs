# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :login_study, LoginStudy.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "XkPeB5VIuE0ZQp8fFfiQdMgy4XmolH+1L5ZUbkk47Awzu8MPT8ZrpE6+SdK8NXFm",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: LoginStudy.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

### Gettext の設定
# http://stackoverflow.com/questions/34538502/how-to-set-locale-for-errors-po
# http://hexdocs.pm/gettext/Gettext.html
config :login_study, LoginStudy.Gettext, default_locale: "ja"


### ログのファイル出力
# https://github.com/onkel-dirtus/logger_file_backend
config :logger,
backends: [
  {LoggerFileBackend, :filelog_debug},
  {LoggerFileBackend, :filelog_info_warn_error},
]

config :logger, :filelog_debug,
  path: "logs/debug.log",
  level: :debug,
  format:   "$date $time\t[$level]\t$metadata\t$message\n",
  metadata: [:request_id]

config :logger, :filelog_info_warn_error,
  path: "logs/phoenix.log",
  level: :info,
  format:   "$date $time\t[$level]\t$metadata\t$message\n",
  metadata: [:request_id]


### メールの設定
config :mailer,
  # templates ディレクトリの指定
  templates: "priv/templates/mail"

config :mailer, :smtp_client,
  transport: :smtp,
  server: "localhost",
  port: 25
