defmodule LoginStudy.Router do
  use LoginStudy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LoginStudy do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    # 登録処理
    get  "/register", RegisterController, :new
    post "/register", RegisterController, :create

    # ログイン
    get    "/login",  LoginController, :new
    post   "/login",  LoginController, :create

  end

  # Other scopes may use custom stacks.
  # scope "/api", LoginStudy do
  #   pipe_through :api
  # end
end
