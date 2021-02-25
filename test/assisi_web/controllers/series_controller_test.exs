defmodule AssisiWeb.SeriesControllerTest do
  use AssisiWeb.ConnCase

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Coherence.User
  alias Assisi.Classes.Class
  alias Assisi.Classes.Student

  @create_attrs %{timeslot: "some timeslot", student_id: 1, class_id: 1}
  @update_attrs %{timeslot: "some updated timeslot", student_id: 1, class_id: 1}
  @invalid_attrs %{timeslot: nil}

  setup %{conn: conn} do
    user =
      User.changeset(
        %User{},
        %{
          name: "hello",
          password: "hello",
          password_confirmation: "hello",
          admin: true,
          email: "hello@example.com"
        }
      )
      |> Repo.insert!()

    _student = Repo.insert!(%Student{first_name: "first", last_name: "last", id: 1})
    _class = Repo.insert!(%Class{name: "some class", id: 1})
    {:ok, conn: assign(conn, :current_user, user), user: user}
  end

  def fixture(:series) do
    {:ok, series} = Classes.create_series(@create_attrs)
    series
  end

  describe "index" do
    test "lists all series", %{conn: conn} do
      conn = get(conn, Routes.series_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Series"
    end
  end

  describe "new series" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.series_path(conn, :new))
      assert html_response(conn, 200) =~ "New Series"
    end
  end

  describe "create series" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.series_path(conn, :create), series: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.series_path(conn, :show, id)

      conn = get(conn, Routes.series_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Series"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.series_path(conn, :create), series: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Series"
    end
  end

  describe "edit series" do
    setup [:create_series]

    test "renders form for editing chosen series", %{conn: conn, series: series} do
      conn = get(conn, Routes.series_path(conn, :edit, series))
      assert html_response(conn, 200) =~ "Edit Series"
    end
  end

  describe "update series" do
    setup [:create_series]

    test "redirects when data is valid", %{conn: conn, series: series} do
      conn = put(conn, Routes.series_path(conn, :update, series), series: @update_attrs)
      assert redirected_to(conn) == Routes.series_path(conn, :show, series)

      conn = get(conn, Routes.series_path(conn, :show, series))
      assert html_response(conn, 200) =~ "some updated timeslot"
    end

    test "renders errors when data is invalid", %{conn: conn, series: series} do
      conn = put(conn, Routes.series_path(conn, :update, series), series: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Series"
    end
  end

  describe "delete series" do
    setup [:create_series]

    test "deletes chosen series", %{conn: conn, series: series} do
      conn = delete(conn, Routes.series_path(conn, :delete, series))
      assert redirected_to(conn) == Routes.series_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.series_path(conn, :show, series))
      end
    end
  end

  defp create_series(_) do
    series = fixture(:series)
    {:ok, series: series}
  end
end
