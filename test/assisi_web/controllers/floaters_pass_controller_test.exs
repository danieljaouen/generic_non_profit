defmodule AssisiWeb.FloatersPassControllerTest do
  use AssisiWeb.ConnCase

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Coherence.User
  alias Assisi.Classes.Student

  @create_attrs %{current_uses: 42, expiration_date: ~D[2010-04-17], max_uses: 42, student_id: 1}
  @update_attrs %{current_uses: 43, expiration_date: ~D[2011-05-18], max_uses: 43, student_id: 1}
  @invalid_attrs %{current_uses: nil, expiration_date: nil, max_uses: nil}

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
    {:ok, conn: assign(conn, :current_user, user), user: user}
  end

  def fixture(:floaters_pass) do
    {:ok, floaters_pass} = Classes.create_floaters_pass(@create_attrs)
    floaters_pass
  end

  describe "index" do
    test "lists all floaters_passes", %{conn: conn} do
      conn = get(conn, Routes.floaters_pass_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Floaters passes"
    end
  end

  describe "new floaters_pass" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.floaters_pass_path(conn, :new))
      assert html_response(conn, 200) =~ "New Floaters pass"
    end
  end

  describe "create floaters_pass" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.floaters_pass_path(conn, :create), floaters_pass: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.floaters_pass_path(conn, :show, id)

      conn = get(conn, Routes.floaters_pass_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Floaters pass"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.floaters_pass_path(conn, :create), floaters_pass: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Floaters pass"
    end
  end

  describe "edit floaters_pass" do
    setup [:create_floaters_pass]

    test "renders form for editing chosen floaters_pass", %{
      conn: conn,
      floaters_pass: floaters_pass
    } do
      conn = get(conn, Routes.floaters_pass_path(conn, :edit, floaters_pass))
      assert html_response(conn, 200) =~ "Edit Floaters pass"
    end
  end

  describe "update floaters_pass" do
    setup [:create_floaters_pass]

    test "redirects when data is valid", %{conn: conn, floaters_pass: floaters_pass} do
      conn =
        put(conn, Routes.floaters_pass_path(conn, :update, floaters_pass),
          floaters_pass: @update_attrs
        )

      assert redirected_to(conn) == Routes.floaters_pass_path(conn, :show, floaters_pass)

      conn = get(conn, Routes.floaters_pass_path(conn, :show, floaters_pass))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, floaters_pass: floaters_pass} do
      conn =
        put(conn, Routes.floaters_pass_path(conn, :update, floaters_pass),
          floaters_pass: @invalid_attrs
        )

      assert html_response(conn, 200) =~ "Edit Floaters pass"
    end
  end

  describe "delete floaters_pass" do
    setup [:create_floaters_pass]

    test "deletes chosen floaters_pass", %{conn: conn, floaters_pass: floaters_pass} do
      conn = delete(conn, Routes.floaters_pass_path(conn, :delete, floaters_pass))
      assert redirected_to(conn) == Routes.floaters_pass_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.floaters_pass_path(conn, :show, floaters_pass))
      end
    end
  end

  defp create_floaters_pass(_) do
    floaters_pass = fixture(:floaters_pass)
    {:ok, floaters_pass: floaters_pass}
  end
end
