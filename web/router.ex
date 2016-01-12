defmodule LoginStudy.Router do
  use LoginStudy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers

    plug LoginStudy.Plug.IPRestrict, [:all]
    plug LoginStudy.Plug.BrowserCookie
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


    get    "/dbtest",  DBTestController, :dbtest
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

    #    get "/:provider", SocialLoginController, :request
    #    get "/:provider/callback", SocialLoginController, :callback

    # plug Ueberauth を設定したコントローラが、OAuth2サーバへのリダイレクトを
    # いいように処理してくれる。atom は何でもいい。
    get "/facebook", SocialLoginController, :dummy
    get "/twitter", SocialLoginController, :dummy

    # callback されるURL
    get "/facebook_callback", SocialLoginController, :facebook_callback
    get "/twitter_callback", SocialLoginController, :twitter_callback



  end



  # Other scopes may use custom stacks.
  # scope "/api", LoginStudy do
  #   pipe_through :api
  # end
end
