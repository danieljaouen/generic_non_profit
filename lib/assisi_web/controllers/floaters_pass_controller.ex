defmodule AssisiWeb.FloatersPassController do
  use AssisiWeb, :controller

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Classes.FloatersPass
  alias Assisi.Classes.Student

  plug :authenticate_user
       when action in [
              :index,
              :new,
              :create,
              :show,
              :edit,
              :update,
              :delete
            ]

  defp authenticate_user(conn, _params) do
    if Coherence.current_user(conn) &&
         Coherence.current_user(conn).admin do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to access that page.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt
    end
  end

  def index(conn, _params) do
    floaters_passes = Classes.list_floaters_passes()
    render(conn, "index.html", floaters_passes: floaters_passes)
  end

  def new(conn, _params) do
    changeset = Classes.change_floaters_pass(%FloatersPass{})
    students = Classes.list_students_without_referrers()
    render(conn, "new.html", changeset: changeset, students: students)
  end

  def create(conn, %{"floaters_pass" => floaters_pass_params}) do
    case Classes.create_floaters_pass(floaters_pass_params) do
      {:ok, floaters_pass} ->
        conn
        |> put_flash(:info, "Floaters pass created successfully.")
        |> redirect(to: Routes.floaters_pass_path(conn, :show, floaters_pass))

      {:error, %Ecto.Changeset{} = changeset} ->
        students = Classes.list_students_without_referrers()
        render(conn, "new.html", changeset: changeset, students: students)
    end
  end

  def show(conn, %{"id" => id}) do
    floaters_pass = Classes.get_floaters_pass!(id)
    render(conn, "show.html", floaters_pass: floaters_pass)
  end

  def edit(conn, %{"id" => id}) do
    floaters_pass = Classes.get_floaters_pass!(id)
    students = Classes.list_students_without_referrers()
    changeset = Classes.change_floaters_pass(floaters_pass)

    render(
      conn,
      "edit.html",
      floaters_pass: floaters_pass,
      changeset: changeset,
      students: students
    )
  end

  def update(conn, %{"id" => id, "floaters_pass" => floaters_pass_params}) do
    floaters_pass = Classes.get_floaters_pass!(id)

    case Classes.update_floaters_pass(floaters_pass, floaters_pass_params) do
      {:ok, floaters_pass} ->
        conn
        |> put_flash(:info, "Floaters pass updated successfully.")
        |> redirect(to: Routes.floaters_pass_path(conn, :show, floaters_pass))

      {:error, %Ecto.Changeset{} = changeset} ->
        students = Classes.list_students_without_referrers()

        render(
          conn,
          "edit.html",
          floaters_pass: floaters_pass,
          changeset: changeset,
          students: students
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    floaters_pass = Classes.get_floaters_pass!(id)
    {:ok, _floaters_pass} = Classes.delete_floaters_pass(floaters_pass)

    conn
    |> put_flash(:info, "Floaters pass deleted successfully.")
    |> redirect(to: Routes.floaters_pass_path(conn, :index))
  end
end
