# phoenix-studies-login
Phoenix によるログインフォームのテスト実装

# 前準備
## MySQLの準備
```
$ mysql -u root  -h127.0.0.1 -p

create database phoenix_studies_login;
grant all privileges on phoenix_studies_login.* TO "testuser"@"localhost" identified by "testpass";
flush privileges;
```

# Phoenix の初期設定

```bash
$ sudo yum install inotify-tools
$ mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v1.1.0/phoenix_new-1.1.0.ez
$ mix phoenix.new login_study --no-brunch --database mysql
```

※--no-brunch を指定しているため、phoenix_html.js は自分で配置しないと、form で `method: get` 以外のリンクを設置すると動かなくなる


***** 【commit】 *****

# ロジック追加
## ユーザテーブルの追加

### 作成するテーブル
- id
- email
- hashed_password
- lastlogin_datetime
- 作成日、更新日

### コマンド
Userモデル、usersテーブルの作成準備

```bash
$ mix phoenix.gen.model User users email:string hashed_password:string lastlogin_at:datetime
```

***** 【commit】 *****

- マイグレーションファイルで、カラムにnull制約、unique制約を追加

***** 【commit】 *****

- テーブル作成

```bash
$ mix ecto.migrate
```

```
mysql> desc users;
+-----------------+---------------------+------+-----+---------+----------------+
| Field           | Type                | Null | Key | Default | Extra          |
+-----------------+---------------------+------+-----+---------+----------------+
| id              | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| email           | varchar(255)        | NO   | UNI | NULL    |                |
| hashed_password | varchar(255)        | NO   |     | NULL    |                |
| lastlogin_at    | datetime            | YES  |     | NULL    |                |
| inserted_at     | datetime            | NO   |     | NULL    |                |
| updated_at      | datetime            | NO   |     | NULL    |                |
+-----------------+---------------------+------+-----+---------+----------------+
```

***** 【commit】 *****




## ルーティングの追加
- /
- /register
  - GET: 初期表示
  - POST: 登録
- /login
- /logout

```bash
$ vi web/router.ex

$ mix phoenix.routes
     page_path  GET   /          LoginStudy.PageController :index
     register_path  GET   /register  LoginStudy.RegisterController :new
     register_path  POST  /register  LoginStudy.RegisterController :create
```

***** 【commit】 *****

## /register の準備

ヘッダに /register へのリンクを追加

***** 【commit】 *****

追加

- controller
- view
- template

***** 【commit】 *****

Userモデルにロジックや validation 追加して、ユーザ登録できるように
  ※Phoenix 1.1.0 の gettext による仕様変更にも対応
  https://gist.github.com/chrismccord/557ef22e2a03a7992624

***** 【commit】 *****

## /login の準備

/login の画面や view を準備

***** 【commit】 *****

ログイン処理を追加

***** 【commit】 *****


## /logout の実装

--no-brunch を指定しているため、js を自分で生成・設置

```bash
 cat deps/phoenix_html/priv/static/phoenix_html.js >> priv/static/js/app.js
```

***** 【commit】 *****

## エラーメッセージの日本語化

外出しした .po ファイルを取り込み

https://github.com/hykw/phoenix-locale_ja

***** 【commit】 *****

## ログイン時間の更新

```elixir
def update_lastlogin(user, repo) do
  user = repo.get(LoginStudy.User, user.id)
  user = %LoginStudy.User{ user | lastlogin_at: now() }

  repo.update user
end
```

***** 【commit】 *****

## ログイン回数登録用のカラムを追加

```bash
$ mix ecto.gen.migration add_logintimes_to_users
```

- マイグレーションファイルに、新しいカラムを追加

- テーブル作成

```bash
$ mix ecto.migrate
```

- ログイン回数を+1するロジック追加

***** 【commit】 *****

- struct を強引に更新して repo.update してた処理を、changeset 経由に修正

***** 【commit】 *****


## ログ出力
- ログをファイル出力

logger_file_backend を追加して、backendsを登録

***** 【commit】 *****

- PlugでLoggerを作って、標準のLoggerと差し替え、Webアクセスのログを出力するようにする

***** 【commit】 *****

## 特定URLにアクセス制限をかける

- /admin, /admin/localonly を作成
  - localhost からのアクセスはあらゆる OK
  - 192.168.x.x からのアクセスもあらゆる OK
  - 10.x.x.x からのアクセスは、/admin/localonly だけ 403
  - それ以外は、/admin も /admin/localonly も 403

***** 【commit】 *****

## アカウント登録時にメール通知

```bash
mkdir priv/templates/mail/register
```

***** 【commit】 *****


## ID指定で無理やりログインする機能

使い所無いかもしれないけど、管理系で何かあるかも

***** 【commit】 *****

## 環境変数から文字列を取得

- 環境変数の Phoenix_Secret_String を取得して、画面に表示する
  - social_login の App Secret とか DB のアカウント情報とかを VCS に入れたくない場合とかを想定

***** 【commit】 *****

## ファイルの読み書きと、外部ファイルの実行

- mix.lock の読み込み
- /tmp/phoenix_test.txt の追記(/bin/date の出力結果)

***** 【commit】 *****

## 秘密情報が書かれた config ファイルを読み込み

- config/secrets/ 以下に、VCS に置きたくない情報を記載した config ファイルを置く
- .gitignore に追加
  - サンプルでは、いったんコメントアウトして config/secrets 以下のファイルをコミットしてある
- (dev|prd).exs で、ファイルを import_config
- `Application.get_env(:login_study, Social_Login, "取得失敗")[:facebook_private_key]`

***** 【commit】 *****


## ソーシャルログイン
### Facebook

データ登録はせず、取得したデータを表示するだけ
with を使ってみた

- [Facebook ページの作成手順](documents/social_login/facebook.md)

***** 【commit】 *****

#### scrogson/oauth2 で実装しなおした

- https://github.com/scrogson/oauth2

***** 【commit】 *****

#### ueberauth/ueberauth で実装しなおした

- https://github.com/ueberauth/ueberauth

***** 【commit】 *****

### Twitter

実装は ueberauth_twitter を利用

- [Twitter ページの作成手順](documents/social_login/twitter.md)

***** 【commit】 *****

## cookieの読み書き

- / にアクセスしたら、COUNT の値を+1する
  - cookieの単純な読み書きで実装

***** 【commit】 *****

- `pipe_through :browser` 内で、PIPE_COOKIE の値を+1する

***** 【commit】 *****

## DBの読み書き

- `SELECT hashed_password FROM users WHERE id = 1` を ecto で実行
  - passlists テーブルに、上記で取得した値を ecto で INSERT

### コマンド

```bash
$ mix phoenix.gen.model DBTest passlists hashed_password:string
$ mix ecto.migrate
```

```
mysql > desc passlists;
+-----------------+---------------------+------+-----+---------+----------------+
| Field           | Type                | Null | Key | Default | Extra          |
+-----------------+---------------------+------+-----+---------+----------------+
| id              | bigint(20) unsigned | NO   | PRI | NULL    | auto_increment |
| hashed_password | varchar(255)        | YES  |     | NULL    |                |
| inserted_at     | datetime            | NO   |     | NULL    |                |
| updated_at      | datetime            | NO   |     | NULL    |                |
+-----------------+---------------------+------+-----+---------+----------------+
```

***** 【commit】 *****

### transaction 内での実行

- passlists にレコード INSERT して (auto)commit
- passlists にレコード INSERT して rollback
- passlists にレコード INSERT して (auto)commit

***** 【commit】 *****


### 親子関係のテーブルの読み書き

- ログインの度に、user.id の子テーブルにレコードを登録
  - put_flash で、レコード数を表示

```bash
$ mix phoenix.gen.model LoginHistory login_history login_at:datetime user_id:integer
```

- マイグレーションファイルを編集、timestamps 削除、複合インデックス追加
  - `create index(:login_history, [:user_id, :login_at], concurrently: true)` にすると、MySQLの場合 SQL エラーになるので注意

```elixir:priv/repo/migrations/20160112073452_create_login_history.exs
defmodule LoginStudy.Repo.Migrations.CreateLoginHistory do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create table(:login_history) do
      add :login_at, :datetime
      add :user_id, :integer
    end

    create index(:login_history, [:user_id, :login_at])

  end
end
```

```bash
$ mix ecto.migrate
```

- 親子関係の紐付け
  - web/models/users.ex
  - web/models/login_history.ex

- iex で確認
```elixir
iex> alias LoginStudy.User
iex> alias LoginStudy.LoginHistory
iex> alias LoginStudy.Repo

iex> user_param = %{email: "foo@example.jp", hashed_password: "pass", login_times: 0}
iex> Repo.insert!(User.changeset(%User{}, user_param))

iex> history_param = %{login_at: "2016-01-12 08:09:10", user_id: 11}
iex> Repo.insert!(LoginHistory.changeset(%LoginHistory{}, history_param))

iex> user = Repo.get(User, 11) |> Repo.preload(:login_history)
iex> login_history = Repo.get(LoginHistory, 1) |> Repo.preload(:user)
```

***** 【commit】 *****


