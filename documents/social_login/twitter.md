# Twitter アプリの作成手順
- アプリケーションを作成するユーザは携帯番号の登録が必須になった（登録せずにアプリを追加しようとするとエラーになる）
- Website欄は、認証確認でキャンセルをした時の戻りURL

## 作成手順
- https://apps.twitter.com/ で「Create New App」をクリック
  - Name: phoenix-studies-login
  - Description: phoenix-studies-login
  - Website: http://example.jp/
  - Callback URL: http://example.jp/social_login/twitter_callback/

## 作成後の設定
- Permissions
    - Read only
