defmodule Facebook do
  use OAuth2.Strategy

  defp read_config_value(key) do
    Application.get_env(:login_study, Social_Login)[key]
  end


  def new do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: read_config_value(:facebook_public_key),
      client_secret: read_config_value(:facebook_private_key),
      redirect_uri: read_config_value(:facebook_redirect_uri),

      site: "https://graph.facebook.com/v2.4",
      authorize_url: "http://www.facebook.com/v2.4/dialog/oauth",
      token_url: "https://graph.facebook.com/oauth/access_token"
    ])
  end

  def authorize_url!(params \\ []) do
    new()
    |> put_param(:scope, "email")
    |> OAuth2.Client.authorize_url!(params)
  end

  def get_token!(params \\ [], headers \\ [], options \\ []) do
    OAuth2.Client.get_token!(new(), params, headers, options)
  end

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_header("Accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
