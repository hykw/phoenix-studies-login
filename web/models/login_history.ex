defmodule LoginStudy.LoginHistory do
  use LoginStudy.Web, :model

  schema "login_history" do
    field :login_at, Ecto.DateTime

    # 外部キーになるので、mix ecto.migrate 実行後は削除する
    #    field :user_id, :integer
    belongs_to :user, LoginStudy.User, foreign_key: :user_id

  end

  @required_fields ~w(login_at user_id)
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
