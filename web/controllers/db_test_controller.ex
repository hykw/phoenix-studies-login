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
    changeset_hash = DBTest.changeset(%DBTest{}, params)
                      |> LoginStudy.DBTest.changeset(%{hashed_password: hash})
                      |> LoginStudy.DBTest.create(LoginStudy.Repo)

    case changeset_hash do
      {:ok, record} ->

        id = record.id
        conn
        |> put_flash(:info, "成功：id=" <> to_string(id))
        |> redirect(to: page_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, "登録失敗" )
        |> redirect(to: page_path(conn, :index))
    end

  end

end

