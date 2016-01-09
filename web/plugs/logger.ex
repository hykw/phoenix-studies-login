defmodule LoginStudy.Plug.Logger do
  import Plug.Conn
  require Logger

  def init(default), do: default

  def call(conn, _default) do
#     Logger.info(fn ->
#       [conn.method, ?\s, conn.request_path]
#     end)

    before_time = :os.timestamp()
    conn
    |> register_before_send(fn conn ->
      req_header_m = Enum.into(conn.req_headers, %{})
      resp_header_m = Enum.into(conn.resp_headers, %{})

      resp_body = if String.contains?(resp_header_m["content-type"] || "", "json") do
        to_string(conn.resp_body)
      else
        ""
      end

      diff = :timer.now_diff(:os.timestamp(), before_time)
              |> div(1000) # to ms

      str_resp_body = resp_body

      Logger.info(
        Enum.join([
          "type:" <> "request",
          "remoteip:" <> Enum.join(Tuple.to_list(conn.remote_ip), ","),
          "method:" <> conn.method,
          "path:" <> conn.request_path,
          "status:" <> to_string(conn.status),
          "size_res:" <> to_string(byte_size(str_resp_body)),
          "diff:" <> to_string(diff),
          "ua:" <> Map.get(req_header_m, "user-agent", ""),
          "referer:" <> Map.get(req_header_m, "referer", ""),
        ], "\t")
      )

      conn
    end)
  end


  # デバッグ用
  defp debug_write() do
    Logger.debug "***debug***"
    Logger.info "***info***"
    Logger.warn "***warn***"
    Logger.error "***error***"
  end

end
