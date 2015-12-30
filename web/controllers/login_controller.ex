defmodule LoginStudy.LoginController do
  use LoginStudy.Web, :controller
  alias LoginStudy.User

  @doc """
  ログイン画面の表示
  """
  def new(conn, _params) do
    render conn, "new.html"
  end
end
