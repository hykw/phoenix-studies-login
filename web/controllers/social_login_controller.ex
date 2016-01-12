defmodule LoginStudy.SocialLoginController do
  use LoginStudy.Web, :controller

  plug Ueberauth


  ### Facebook
  def facebook_callback(%{ assigns: %{ ueberauth_failure: _fails } } = conn, params) do
    error_description = params["error_description"]
    error_msg = "facebook:取得エラー(" <> error_description <> ")"

    conn
    |> put_flash(:error, error_msg)
    |> redirect(to: page_path(conn, :index))
  end


  # ダイアログで email の権限を落とした場合
  def facebook_callback(%{ assigns: %{ueberauth_auth: _auth}, assigns: %{ueberauth_auth: %{ info: %{ email: nil } }}} = conn, _params) do
    error_msg = "facebook:メールアドレスが取得できませんでした"

    conn
    |> put_flash(:error, error_msg)
    |> redirect(to: page_path(conn, :index))
  end


  def facebook_callback(%{ assigns: %{ueberauth_auth: auth} } = conn, _params) do
    social_data = "#{auth.info.name}, #{auth.info.email}"

    conn
    |> put_flash(:info, "facebook:取得できた(" <> social_data <> ")")
    |> redirect(to: page_path(conn, :index))
  end

  ##################################################

  ### Twitter
  def twitter_callback(%{ assigns: %{ ueberauth_failure: fails } } = conn, _params) do
    # twitter はエラー理由はほとんど返さないのでシンプル
    error_msg = "twitter:取得エラー"

    conn
    |> put_flash(:error, error_msg)
    |> redirect(to: page_path(conn, :index))
  end


  def twitter_callback(%{ assigns: %{ueberauth_auth: auth} } = conn, _params) do
    IO.inspect auth

    # emailは取れない
    social_data = "#{auth.info.name}"

    conn
    |> put_flash(:info, "twitter:取得できた(" <> social_data <> ")")
    |> redirect(to: page_path(conn, :index))
  end


end
