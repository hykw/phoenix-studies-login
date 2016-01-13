defmodule LoginStudy.LoginController do
  use LoginStudy.Web, :controller
  alias LoginStudy.User

  ~S"""
  ログイン画面の表示
  """
  def new(conn, _params) do
    render conn, :new
  end


  ~S"""
  ログイン処理
  """
  def create(conn, %{"login" => session_params}) do
    # http://www.phoenixframework.org/docs/sessions

    case LoginStudy.Login.login(session_params, LoginStudy.Repo) do
      {:ok, user} ->
        # ログイン時間の更新
        User.update_lastlogin(user, LoginStudy.Repo)

        # ログイン回数の更新
        User.update_login_times(user, LoginStudy.Repo)

        conn
        |> login(user.id)
        |> put_flash(:info, "ログインしました(id = " <> to_string(user.id) <> ")")
        |> redirect(to: page_path(conn, :index))

      :error ->
        conn
        |> put_flash(:info, "メールアドレスもしくはパスワードが間違っています")
        |> render(:new)
    end
  end


  ~S"""
  ログアウト
  """
  def delete(conn, _) do
    conn
    |> logout()
    |> put_flash(:info, "ログアウトしました")
    |> redirect(to: page_path(conn, :index))
  end


  defp login(conn, user_id) do
    # ログイン時、セッションにログイン日時をセット
    now_datetime = Ecto.DateTime.from_erl(:calendar.universal_time)
    now = Ecto.DateTime.to_string(now_datetime)


    conn
    |> put_session(:current_user, user_id)
    |> put_session(:login_at, now)
  end

  defp logout(conn) do

    # 下記だと、cookie が削除されるだけでサーバ側のセッションは残ったままになる
  #    conn
  #  |> delete_session(:current_user)

    conn
    |> configure_session(drop: true)
  end



  ~S"""
  ID=1 で強制的にログインしちゃう
  """
  def login1(conn, _) do
    # ログインしてたら、まずログアウト
    if LoginStudy.Login.current_user(conn), do: logout(conn)

    user_id = 1

    conn
    |> login(user_id)
    |> put_flash(:info, "無理やりログインしました(id = " <> to_string(user_id) <> ")")
    |> redirect(to: page_path(conn, :index))
  end

end
