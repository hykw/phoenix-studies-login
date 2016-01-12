defmodule LoginStudy.DBTestController do
  use LoginStudy.Web, :controller
  alias LoginStudy.User
  alias LoginStudy.DBTest

  import Ecto.Changeset


  def dbtest(conn, _params) do
    user = Repo.get!(User, 1)
    changeset = User.changeset(user)
    hash = get_field(changeset, :hashed_password)

    params = %{"hashed_password" => hash}


    ### commit, rollback, commit を実行して、commit/rollback をテスト
    # テストのためだけなので、if でべったり汚く書いてるけど、気にしない。

    # 初回(commit)
    end_flag = false
    case LoginStudy.Repo.transaction(fn ->
      DBTest.changeset(%DBTest{}, params)
      |> LoginStudy.DBTest.changeset(%{hashed_password: hash})
      |> LoginStudy.DBTest.create(LoginStudy.Repo)

    end) do
      {:error, _} ->
        conn
        |> put_flash(:error, "トランザクションでエラー(初回)" )
        |> redirect(to: page_path(conn, :index))

        end_flag = true

        {:ok, _} ->
          end_flag = false

    end

    # 二回目(rollback)
    if end_flag == false do
      case LoginStudy.Repo.transaction(fn ->
        DBTest.changeset(%DBTest{}, params)
        |> LoginStudy.DBTest.changeset(%{hashed_password: hash})
        |> LoginStudy.DBTest.create(LoginStudy.Repo)
        LoginStudy.Repo.rollback(:test)

      end) do
        # rollback したら error になるので、ok は逆にエラー
        {:ok, _} ->
        conn
        |> put_flash(:error, "rollbackでエラー" )
        |> redirect(to: page_path(conn, :index))

        end_flag = true
        {:error, _} ->
          end_flag = false

      end
    end

    # 三回目(commit)
    if end_flag == false do
      case LoginStudy.Repo.transaction(fn ->
        changeset_hash = DBTest.changeset(%DBTest{}, params)
                          |> LoginStudy.DBTest.changeset(%{hashed_password: hash})
                          |> LoginStudy.DBTest.create(LoginStudy.Repo)

      end) do
        {:error, _} ->
          conn
          |> put_flash(:error, "トランザクションでエラー（三回目）" )
          |> redirect(to: page_path(conn, :index))

        {:ok, _} ->
          conn
          |> put_flash(:info, "成功")
          |> redirect(to: page_path(conn, :index))

      end
    end
  end
end

