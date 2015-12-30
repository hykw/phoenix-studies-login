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
mix ecto.migrate
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

