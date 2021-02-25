defmodule AssisiWeb.PageControllerTest do
  use AssisiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Yoga"
  end
end
