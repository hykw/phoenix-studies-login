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

