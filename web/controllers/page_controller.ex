defmodule LoginStudy.PageController do
  use LoginStudy.Web, :controller

  def index(conn, _params) do

    # 環境変数の読み込み
    env_secret = System.get_env("Phoenix_Secret_String")
    if !env_secret do
      env_secret = "取得失敗"
    end

    # 秘密のconfigの値を取得
    config_private = Application.get_env(:login_study, Social_Login, "取得失敗")[:facebook_private_key]



    ## ファイルの読み書き
    # 読み込み
    file_read = "mix.lock"
    file_contents = case File.read(file_read) do
      {:ok, res} -> res
      {:error, _} -> "取得失敗"
    end

    # 書き込み（追記）、しかも外部コマンド呼び出し
    file_write = "/tmp/phoenix_test.txt"
    {cmd_result, _exit_status} = System.cmd("/bin/date", [])
    File.write(file_write, cmd_result, [:append])

    assigns = [
      env_secret: env_secret,
      config_private: config_private,
      file_contents: file_contents,
    ]


    ### cookie の読み書き
    cookie_key = "COUNT"

    count = conn.cookies
    |> Map.get(cookie_key, "0")
    |> String.to_integer()

    conn
    |> Plug.Conn.put_resp_cookie(cookie_key, to_string(count+1))
    |> render(:index, assigns)

  end
end
