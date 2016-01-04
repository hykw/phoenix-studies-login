defmodule LoginStudy.AdminController do
  use LoginStudy.Web, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def localonly(conn, _params) do
    render(conn, :localonly)
  end


end
