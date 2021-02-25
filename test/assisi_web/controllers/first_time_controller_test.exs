defmodule AssisiWeb.FirstTimeControllerTest do
  use AssisiWeb.ConnCase

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Coherence.User
  alias Assisi.Classes.Class
  alias Assisi.Classes.Student

  @create_attrs %{date: ~D[2010-04-17], timeslot: "some timeslot", student_id: 1, class_id: 1}
  @update_attrs %{
    date: ~D[2011-05-18],
    timeslot: "some updated timeslot",
    student_id: 1,
    class_id: 1
  }
  @invalid_attrs %{date: nil, timeslot: nil}

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

  def fixture(:first_time) do
    {:ok, first_time} = Classes.create_first_time(@create_attrs)
    first_time
  end

  describe "index" do
    test "lists all first_times", %{conn: conn} do
      conn = get(conn, Routes.first_time_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing First times"
    end
  end

  describe "new first_time" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.first_time_path(conn, :new))
      assert html_response(conn, 200) =~ "New First time"
    end
  end

  describe "create first_time" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.first_time_path(conn, :create), first_time: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.first_time_path(conn, :show, id)

      conn = get(conn, Routes.first_time_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show First time"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.first_time_path(conn, :create), first_time: @invalid_attrs)
      assert html_response(conn, 200) =~ "New First time"
    end
  end

  describe "edit first_time" do
    setup [:create_first_time]

    test "renders form for editing chosen first_time", %{conn: conn, first_time: first_time} do
      conn = get(conn, Routes.first_time_path(conn, :edit, first_time))
      assert html_response(conn, 200) =~ "Edit First time"
    end
  end

  describe "update first_time" do
    setup [:create_first_time]

    test "redirects when data is valid", %{conn: conn, first_time: first_time} do
      conn =
        put(conn, Routes.first_time_path(conn, :update, first_time), first_time: @update_attrs)

      assert redirected_to(conn) == Routes.first_time_path(conn, :show, first_time)

      conn = get(conn, Routes.first_time_path(conn, :show, first_time))
      assert html_response(conn, 200) =~ "some updated timeslot"
    end

    test "renders errors when data is invalid", %{conn: conn, first_time: first_time} do
      conn =
        put(conn, Routes.first_time_path(conn, :update, first_time), first_time: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit First time"
    end
  end

  describe "delete first_time" do
    setup [:create_first_time]

    test "deletes chosen first_time", %{conn: conn, first_time: first_time} do
      conn = delete(conn, Routes.first_time_path(conn, :delete, first_time))
      assert redirected_to(conn) == Routes.first_time_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.first_time_path(conn, :show, first_time))
      end
    end
  end

  defp create_first_time(_) do
    first_time = fixture(:first_time)
    {:ok, first_time: first_time}
  end
end
