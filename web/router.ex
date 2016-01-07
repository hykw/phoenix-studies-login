defmodule LoginStudy.Router do
  use LoginStudy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug LoginStudy.Plug.IPRestrict, [:all]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # 信頼できるIP, ローカルIPはOK
  pipeline :admin do
    plug LoginStudy.Plug.IPRestrict, [:admin]
  end
  # 信頼できるIPもNG(ローカルIPだけOK)
  pipeline :admin_local do
    plug LoginStudy.Plug.IPRestrict, [:localonly]
  end


  scope "/", LoginStudy do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    # 登録処理
    get  "/register", RegisterController, :new
    post "/register", RegisterController, :create

    # ログイン・ログアウト
    get    "/login",  LoginController, :new
    post   "/login",  LoginController, :create

    delete "/logout", LoginController, :delete

    get    "/login1",  LoginController, :login1
  end


  # IP制限テスト
  scope "/admin", LoginStudy do
    # Every time pipe_through/1 is called, the new pipelines are appended
    # to the ones previously given.
    pipe_through :browser
    pipe_through :admin

    get "/", AdminController, :index
  end

  scope "/admin", LoginStudy do
    pipe_through :browser
    pipe_through :admin_local

    get "/localonly", AdminController, :localonly
  end


  ### ソーシャルログイン
  scope "/social_login", LoginStudy do
    pipe_through :browser

    get "/facebook_login", SocialLoginController, :facebook_login
    get "/facebook", SocialLoginController, :facebook_redirect_back


    #    get "/twitter_login", SocialLoginController, :twitter_login


    # 戻ってきた
#     get "/oauth_twitter", SocialTwitterController, :oauth_twitter

  end



  # Other scopes may use custom stacks.
  # scope "/api", LoginStudy do
  #   pipe_through :api
  # end
end
