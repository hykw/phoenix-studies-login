defmodule LoginStudy.LoginController do
  use LoginStudy.Web, :controller
  alias LoginStudy.User

  @doc """
  ログイン画面の表示
  """
  def new(conn, _params) do
    render conn, "new.html"
  end


  @doc """
  ログイン処理
  """
  def create(conn, %{"login" => session_params}) do
    # http://www.phoenixframework.org/docs/sessions

    case LoginStudy.Login.login(session_params, LoginStudy.Repo) do
      {:ok, user} ->
        # ログイン時間の更新
        LoginStudy.User.update_lastlogin(user, LoginStudy.Repo)

        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "ログインしました(id = " <> to_string(user.id) <> ")")
        |> redirect(to: page_path(conn, :index))

      :error ->
        conn
        |> put_flash(:info, "メールアドレスもしくはパスワードが間違っています")
        |> render("new.html")
    end
  end


  @doc """
  ログアウト
  """
  def delete(conn, _) do
    conn
    |> delete_session(:current_user)
    |> put_flash(:info, "ログアウトしました")
    |> redirect(to: page_path(conn, :index))
  end

end
