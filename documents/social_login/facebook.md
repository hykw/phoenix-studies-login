# Facebook ページの作成手順

- https://developers.facebook.com/ から、右上の MyApps ダイアログの Add a New App をクリック
  - Facebook Canvas を選択
  - Skip and Create App ID
    - Display Name：phoenix-studies-login
    - Namespace：phoenix-test-login
    - Is this a test version of another app?：No
    - Category: Apps for Pages

- 設定情報を取得
  - App ID
  - API Version
  - App Secret

## 作成後の設定
### Settings
- Basic
  - Contact Email: foo@example.jp
  - Add Platform
  - Website を選択
    - Site URL: http://example.jp/

- Advanced
  - Client OAuth Settings
    - Valid OAuth redirect URIs: http://example.jp/social_login/facebook/

- Status & Review
    - publicに公開する？(= !sandbox): Yes
        - Noにしちゃうと、自分のアカウントに紐付いているアプリにしかアクセスできなくなるので注意
