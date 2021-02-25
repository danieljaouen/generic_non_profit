defmodule AssisiWeb.ClassControllerTest do
  use AssisiWeb.ConnCase

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Coherence.User

  @create_attrs %{
    name: "some name",
    class_date: ~D[2010-04-17],
    drop_in_cost: 42,
    end_date: ~D[2010-04-17],
    recurrent_or_one_time: "some recurrent_or_one_time",
    start_date: ~D[2010-04-17]
  }
  @update_attrs %{
    name: "some name",
    class_date: ~D[2011-05-18],
    drop_in_cost: 43,
    end_date: ~D[2011-05-18],
    recurrent_or_one_time: "some updated recurrent_or_one_time",
    start_date: ~D[2011-05-18]
  }
  @invalid_attrs %{
    class_date: nil,
    drop_in_cost: nil,
    end_date: nil,
    recurrent_or_one_time: nil,
    start_date: nil
  }

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

    {:ok, conn: assign(conn, :current_user, user), user: user}
  end

  def fixture(:class) do
    {:ok, class} = Classes.create_class(@create_attrs)
    class
  end

  describe "index" do
    test "lists all classes", %{conn: conn} do
      conn = get(conn, Routes.class_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Classes"
    end
  end

  describe "new class" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.class_path(conn, :new))
      assert html_response(conn, 200) =~ "New Class"
    end
  end

  describe "create class" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = post(conn, Routes.class_path(conn, :create), class: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.class_path(conn, :show, id)

      conn = get(conn, Routes.class_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Class"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.class_path(conn, :create), class: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Class"
    end
  end

  describe "edit class" do
    setup [:create_class]

    test "renders form for editing chosen class", %{conn: conn, class: class} do
      conn = get(conn, Routes.class_path(conn, :edit, class))
      assert html_response(conn, 200) =~ "Edit Class"
    end
  end

  describe "update class" do
    setup [:create_class]

    test "redirects when data is valid", %{conn: conn, class: class} do
      conn = put(conn, Routes.class_path(conn, :update, class), class: @update_attrs)
      assert redirected_to(conn) == Routes.class_path(conn, :show, class)

      conn = get(conn, Routes.class_path(conn, :show, class))
      assert html_response(conn, 200) =~ "some updated recurrent_or_one_time"
    end

    test "renders errors when data is invalid", %{conn: conn, class: class} do
      conn = put(conn, Routes.class_path(conn, :update, class), class: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Class"
    end
  end

  describe "delete class" do
    setup [:create_class]

    test "deletes chosen class", %{conn: conn, class: class} do
      conn = delete(conn, Routes.class_path(conn, :delete, class))
      assert redirected_to(conn) == Routes.class_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.class_path(conn, :show, class))
      end
    end
  end

  defp create_class(_) do
    class = fixture(:class)
    {:ok, class: class}
  end
end
