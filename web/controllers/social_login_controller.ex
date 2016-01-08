defmodule LoginStudy.SocialLoginController do
  use LoginStudy.Web, :controller

  plug Ueberauth


  ### Facebook
  def facebook_callback(%{ assigns: %{ ueberauth_failure: fails } } = conn, params) do
    error_description = params["error_description"]
    error_msg = "取得エラー(" <> error_description <> ")"

    conn
    |> put_flash(:error, error_msg)
    |> redirect(to: page_path(conn, :index))
  end


  # ダイアログで email の権限を落とした場合
  def facebook_callback(%{ assigns: %{ueberauth_auth: auth}, assigns: %{ueberauth_auth: %{ info: %{ email: nil } }}} = conn, params) do
    error_msg = "メールアドレスが取得できませんでした"

    conn
    |> put_flash(:error, error_msg)
    |> redirect(to: page_path(conn, :index))
  end


  def facebook_callback(%{ assigns: %{ueberauth_auth: auth} } = conn, params) do
    social_data = "#{auth.info.name}, #{auth.info.email}"

    conn
    |> put_flash(:info, "取得できた(" <> social_data <> ")")
    |> redirect(to: page_path(conn, :index))
  end

end
