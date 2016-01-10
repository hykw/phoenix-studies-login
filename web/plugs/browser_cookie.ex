defmodule LoginStudy.Plug.BrowserCookie do
  import Plug.Conn

  def init(default), do: default

  def call(conn, params) do

    cookie_key = "PIPE_COOKIE"
    max_age = 60*60*24 * 7

    count = conn.cookies
            |> Map.get(cookie_key, "0")
            |> String.to_integer()

    conn
    |> Plug.Conn.put_resp_cookie(cookie_key, to_string(count+1))

  end
end


