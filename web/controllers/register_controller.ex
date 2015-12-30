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

    render(conn, "new.html", changeset: changeset)
  end

  @doc """
  登録処理
  """
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    # http://www.phoenixframework.org/docs/ecto-models
    case User.create(changeset, LoginStudy.Repo) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "アカウントを作成(メールアドレス = " <> changeset.params["email"] <> ")")
        |> redirect(to: page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:info, "アカウント作成失敗")
        |> render("new.html", changeset: changeset)
    end

  end

end
