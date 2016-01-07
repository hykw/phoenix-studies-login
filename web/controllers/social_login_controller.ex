defmodule LoginStudy.SocialLoginController do
  use LoginStudy.Web, :controller

  ### Facebook
  def facebook_login(conn, _params) do
    redirect conn, external: Facebook.authorize_url!
  end

  @doc """
  facebook から戻ってきた時の処理
  """
  def facebook_redirect_back(conn, %{"code" => code}) do

    access_token = Facebook.get_token!(code: code)

    fields = "id,name,birthday,email"
    locale = "ja_JP"
    url_me = "/me?fields=#{fields}&locale=#{locale}"

    case OAuth2.AccessToken.get!(access_token, url_me) do
      %OAuth2.Response{status_code: status_code, body: body} when status_code in 200..399 ->
        parse_facebook_userdata(conn, body)

      _ ->
        error_description = "取得エラー"
        render_data = render(conn, "redirect_error.html", error_msg: error_description)
    end
  end

  defp parse_facebook_userdata(conn, json_user_data) do
    ud = Poison.Decode.decode(json_user_data, [])

    name = ud["name"]
    email = ud["email"]
    id = ud["id"]

    parsed_userdata = "#{name}, #{email}, #{id}"
    render(conn, "got.html", social_data: parsed_userdata)
  end



end
