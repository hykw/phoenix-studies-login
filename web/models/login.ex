defmodule LoginStudy.Login do
  alias LoginStudy.User

  ~S"""
  ログイン処理
  """
  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  ~S"""
  認証処理
  """
  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.hashed_password)
    end
  end


  ~S"""
  現在のログインユーザを取得
  """
  def current_user(conn) do
    # http://www.phoenixframework.org/docs/sessions

    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: LoginStudy.Repo.get(User, id)
  end


  ~S"""
  ログインしているかどうかを返す
  """
  def logged_in?(conn) do
    !!current_user(conn)
  end



end

