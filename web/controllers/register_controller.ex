defmodule LoginStudy.RegisterController do
  use LoginStudy.Web, :controller
  alias LoginStudy.User

  @moduledoc """
  /register のコントローラ
  """

  @doc """
  新規表示
  """
  def new(conn, _params) do
    changeset = User.changeset(%User{})

    render(conn, :new, changeset: changeset)
  end

  @doc """
  登録処理
  """
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    # http://www.phoenixframework.org/docs/ecto-models
    case User.create(changeset, LoginStudy.Repo) do
      # ユーザ登録時、ログインも一緒に

      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "アカウントを作成(メールアドレス = " <> changeset.params["email"] <> ")")
        |> redirect(to: page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:info, "アカウント作成失敗")
        |> render(:new, changeset: changeset)
    end

  end

end
