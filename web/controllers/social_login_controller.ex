defmodule LoginStudy.SocialLoginController do
  use LoginStudy.Web, :controller

  def facebook_login(conn, _params) do

    client_id = read_config_value(:facebook_public_key)
    redirect_uri = read_config_value(:facebook_redirect_uri)

    uri = "http://www.facebook.com/v2.4/dialog/oauth?auth_type=rerequest&client_id=#{client_id}&scope=email&redirect_uri=#{redirect_uri}"

    conn
    |> redirect(external: uri)

  end


  @doc """
  facebook から戻ってきた時の処理
  """
  def facebook_redirect_back(conn, params) do


    """
    %{"code" => "xxxxxx"}
    %{"error" => "access_denied", "error_code" => "200", "error_description" => "Permissions error", "error_reason" => "user_denied"}
    """
    case params do
      %{"error" => _err_value, "error_description" => err_desc } ->
        render(conn, "redirect_error.html", error_msg: err_desc)

      %{"code" => code} ->
        client_id = read_config_value(:facebook_public_key)
        redirect_uri = read_config_value(:facebook_redirect_uri)
        client_secret = read_config_value(:facebook_private_key)

        with {:ok, access_token} <- fetch_facebook_token(conn, client_id, redirect_uri, client_secret, code),
             {:ok, user_data} <- fetch_facebook_userdata(conn, access_token),
             {:ok, render_data} <- parse_facebook_userdata(conn, user_data),
             do: {:ok, render_data}
    end

  end


  ##################################################
  defp read_config_value(key) do
    Application.get_env(:login_study, Social_Login)[key]
  end


  @doc """
  access_token を取得

  {:ok, access_token}
  {:error, renderの値}
  """
  defp fetch_facebook_token(conn, client_id, redirect_uri, client_secret, code) do
    url_access_token = "https://graph.facebook.com/oauth/access_token?client_id=#{client_id}&redirect_uri=#{redirect_uri}&client_secret=#{client_secret}&code=#{code}"

    {:ok, res} = HTTPoison.get(url_access_token)

    if res.status_code == 200 do
      {:ok, res.body}
    else
      error_description = "access error(token)"
      render_data = render(conn, "redirect_error.html", error_msg: error_description)
      {:error, render_data}
    end
  end


  @doc """
  ユーザ情報の取得

  {:ok, user_data}
  {:error, renderの値}
  """
  defp fetch_facebook_userdata(conn, access_token) do
    fields = "id,name,birthday,email"
    locale = "&locale=ja_JP"

    url_me = "https://graph.facebook.com/v2.4/me?fields=#{fields}&locale=#{locale}&#{access_token}"

    {:ok, res} = HTTPoison.get(url_me)

    if res.status_code == 200 do
      {:ok, res.body}
    else
      error_description = "access error(me)"
      render_data = render(conn, "redirect_error.html", error_msg: error_description)
      {:error, render_data}
    end
  end


  defp parse_facebook_userdata(conn, user_data) do
    ud = Poison.decode!(user_data)

    name = ud["name"]
    email = ud["email"]

    parsed_userdata = "#{name}, #{email}"
    render(conn, "got.html", social_data: parsed_userdata)
  end



end
