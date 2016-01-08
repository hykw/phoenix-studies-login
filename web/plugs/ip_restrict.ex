# http://qiita.com/FL4TLiN3/items/18fa81c30fc9aeba7223

defmodule LoginStudy.Plug.IPRestrict do
  import Plug.Conn
  require Logger

  def init(default), do: default

  def call(conn, params) do


    ~S"""
    localhost からのアクセスはあらゆる OK

    192.168.x.x からのアクセスもあらゆる OK
    10.x.x.x からのアクセスは、:localonly だけ NG
    それ以外は、:admin も :localonly も NG
    """

    ip = conn.remote_ip

    # アクセス全部OK
    if ip == {127, 0, 0, 1} do
      conn
    else
      case ip do
        {192, 168, _, _} ->
          conn

        {10, _, _, _} ->
          if params == [:localonly] do
            send403 conn
          else
            conn
          end

        _ ->
          if params == [:localonly] or params == [:admin] do
            send403 conn
          else
            conn
          end
      end

    end

  end

  defp send403(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(403, "Permission denied!")
  end
end


