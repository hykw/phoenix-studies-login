defmodule LoginStudy.User do
  use LoginStudy.Web, :model

  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :lastlogin_at, Ecto.DateTime

    # 保存しないので virtual field として定義
    field :password, :string, virtual: true

    timestamps
  end

  @required_fields ~w(email password)
  @optional_fields ~w()


  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    # http://hexdocs.pm/ecto/Ecto.Changeset.html#functions

    # テストのため、パスワードは数字2〜4桁のみOKとする
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 2, max: 4)
    |> validate_format(:password, ~r/^[0-9]*$/)
  end


  @doc """
  userレコードを作成
  """
  def create(changeset, repo) do

    # lastlogin_at を生成

    changeset
    |> put_change(:hashed_password, hash_password(changeset.params["password"]))
    |> put_change(:lastlogin_at, now())
    |> repo.insert()
  end

  # パスワードをハッシュ化
  defp hash_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  defp now() do
    # http://qiita.com/FL4TLiN3/items/5fcf57677a1c0123637d
    Ecto.DateTime.from_erl(:calendar.local_time)
  end


end
