defmodule LoginStudy.User do
  use LoginStudy.Web, :model

  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :lastlogin_at, Ecto.DateTime

    timestamps
  end

  @required_fields ~w(email hashed_password lastlogin_at)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
