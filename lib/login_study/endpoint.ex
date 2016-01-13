defmodule LoginStudy.Endpoint do
  use Phoenix.Endpoint, otp_app: :login_study

  socket "/socket", LoginStudy.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :login_study, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId

  # 入れ替え
  #  plug Plug.Logger
  plug LoginStudy.Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
  #  key: "_login_study_key",
  #  signing_salt: "0vMEQtSg"
    store: :memcached,
    key: "session_key",
    table: :memcached_sessions,
    signing_salt: "0vMEQtSg",
    encryption_salt: "12345",

    #    secure: true,
    max_age: 86400 * 365  # 1year

  plug LoginStudy.Router
end
