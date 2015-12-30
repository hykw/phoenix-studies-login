defmodule LoginStudy.RegisterController do
  use LoginStudy.Web, :controller
  alias LoginStudy.User

  @doc """
  /register のコントローラ
  """
  def new(conn, _params) do
    changeset = User.changeset(%User{})

    render(conn, "new.html", changeset: changeset)
  end
end
