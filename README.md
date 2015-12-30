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

