defmodule LoginStudy.PageController do
  use LoginStudy.Web, :controller

  def index(conn, _params) do

    env_secret = System.get_env("Phoenix_Secret_String")
    if !env_secret do
      env_secret = "取得失敗"
    end

    render(conn, :index, env_secret: env_secret)
  end
end
