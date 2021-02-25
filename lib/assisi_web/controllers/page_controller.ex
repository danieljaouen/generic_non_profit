defmodule AssisiWeb.PageController do
  use AssisiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
