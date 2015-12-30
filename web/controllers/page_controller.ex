defmodule LoginStudy.PageController do
  use LoginStudy.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
