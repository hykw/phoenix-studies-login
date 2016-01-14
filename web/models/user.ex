defmodule LoginStudy.User do
  use LoginStudy.Web, :model

  schema "users" do
    field :email, :string
    field :hashed_password, :string
    field :lastlogin_at, Ecto.DateTime
    field :login_times, :integer

    # 保存しないので virtual field として定義
    field :password, :string, virtual: true

    has_many :login_history, LoginStudy.LoginHistory


    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w(password hashed_password lastlogin_at login_times)


  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    # http://hexdocs.pm/ecto/Ecto.Changeset.html#functions


    # パラメータの正規化
    normalized_params = normalize_parameter(params)

    # テストのため、パスワードは数字2〜4桁のみOKとする
    model
    |> cast(normalized_params, @required_fields, @optional_fields)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 2, max: 4)
    |> validate_format(:password, ~r/^[0-9]*$/)
  end

    #    |> validate_format(:password, ~r/^[0-9]*$/, [message: "あいうえお"])


  def normalize_parameter(params) do
    if params === :empty do
      params
    else
      email = python_multibytes(params["email"])
      password = python_multibytes(params["password"])

      %{ params | "email" => email, "password" => password }
    end

  end

  def python_multibytes(nil) do "" end
  def python_multibytes(arg) do
    {cmd_result, exit_status} = System.cmd("python", ["priv/python/multibytes.py", arg], parallelism: true)

    # 何かエラーが起きた時は、変換しないでまま返す
    if exit_status === 0 do
      String.rstrip(cmd_result)
    else
      arg
    end

  end



  ~S"""
  userレコードを作成
  """
  def create(changeset, repo) do

    # lastlogin_at を生成

    changeset
    |> put_change(:hashed_password, hash_password(changeset.params["password"]))
    |> put_change(:lastlogin_at, now())
    |> put_change(:login_times, 0)
    |> repo.insert()
  end

  # パスワードをハッシュ化
  defp hash_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

  defp now() do
    # http://qiita.com/FL4TLiN3/items/5fcf57677a1c0123637d
    Ecto.DateTime.from_erl(:calendar.universal_time)
  end


  ~S"""
  ログイン時間の更新
  """
  def update_lastlogin(user, repo) do

    ~S"""
    validation をすっ飛ばしたい場合は change() を使う

      # changsetのchanges に直接injectするため、validationは飛ばされちゃう
      user = repo.get(LoginStudy.User, user.id)
      changeset = change(user, %{email: "xxx"})
      repo.update(changeset)
    """

    user = repo.get(LoginStudy.User, user.id)

    changeset = LoginStudy.User.changeset(user, %{lastlogin_at: now()})
    # changeset = LoginStudy.User.changeset(user, %{email: "aaaa.com"})

    ~S"""
    ここで changeset.valid? が true かどうかのチェックをいれてもいいけど、
      ・repo.update を呼び出してもエラーになるわけでもないし（もちろんUPDATEもされない）
      ・ユーザ入力値が無いので、エラーになる可能性が低い
      ・エラーになったとしても、ログイン処理自体は続行しても支障がない
    ので、ノーチェックでも良さそう(これが Elixir way っぽい？)
    """
    repo.update changeset
  end

  ~S"""
  ログイン回数の更新
  """
  def update_login_times(user, repo) do
    user = repo.get(LoginStudy.User, user.id)

    changeset = LoginStudy.User.changeset(user, %{login_times: user.login_times+1})
    repo.update changeset
  end


end
