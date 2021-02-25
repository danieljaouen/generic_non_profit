defmodule AssisiWeb.DropInControllerTest do
  use AssisiWeb.ConnCase

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Coherence.User
  alias Assisi.Classes.Class
  alias Assisi.Classes.Student

  @create_attrs %{
    date: ~D[2010-04-17],
    paid: true,
    timeslot: "some timeslot",
    student_id: 1,
    class_id: 1
  }
  @update_attrs %{
    date: ~D[2011-05-18],
    paid: false,
    timeslot: "some updated timeslot",
    student_id: 1,
    class_id: 1
  }
  @invalid_attrs %{date: nil, paid: nil, timeslot: nil}

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

  def fixture(:drop_in) do
    {:ok, drop_in} = Classes.create_drop_in(@create_attrs)
    drop_in
  end

  describe "index" do
    test "lists all drop_ins", %{conn: conn} do
      conn = get(conn, Routes.drop_in_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Drop ins"
    end
  end

  describe "new drop_in" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.drop_in_path(conn, :new))
      assert html_response(conn, 200) =~ "New Drop in"
    end
  end

  describe "create drop_in" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.drop_in_path(conn, :create), drop_in: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.drop_in_path(conn, :show, id)

      conn = get(conn, Routes.drop_in_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Drop in"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.drop_in_path(conn, :create), drop_in: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Drop in"
    end
  end

  describe "edit drop_in" do
    setup [:create_drop_in]

    test "renders form for editing chosen drop_in", %{conn: conn, drop_in: drop_in} do
      conn = get(conn, Routes.drop_in_path(conn, :edit, drop_in))
      assert html_response(conn, 200) =~ "Edit Drop in"
    end
  end

  describe "update drop_in" do
    setup [:create_drop_in]

    test "redirects when data is valid", %{conn: conn, drop_in: drop_in} do
      conn = put(conn, Routes.drop_in_path(conn, :update, drop_in), drop_in: @update_attrs)
      assert redirected_to(conn) == Routes.drop_in_path(conn, :show, drop_in)

      conn = get(conn, Routes.drop_in_path(conn, :show, drop_in))
      assert html_response(conn, 200) =~ "some updated timeslot"
    end

    test "renders errors when data is invalid", %{conn: conn, drop_in: drop_in} do
      conn = put(conn, Routes.drop_in_path(conn, :update, drop_in), drop_in: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Drop in"
    end
  end

  describe "delete drop_in" do
    setup [:create_drop_in]

    test "deletes chosen drop_in", %{conn: conn, drop_in: drop_in} do
      conn = delete(conn, Routes.drop_in_path(conn, :delete, drop_in))
      assert redirected_to(conn) == Routes.drop_in_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.drop_in_path(conn, :show, drop_in))
      end
    end
  end

  defp create_drop_in(_) do
    drop_in = fixture(:drop_in)
    {:ok, drop_in: drop_in}
  end
end
