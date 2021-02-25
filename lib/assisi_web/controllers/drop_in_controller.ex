defmodule AssisiWeb.DropInController do
  use AssisiWeb, :controller

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Classes.DropIn
  alias Assisi.Classes.Student
  alias Assisi.Classes.Class

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
    drop_ins = Classes.list_drop_ins()
    render(conn, "index.html", drop_ins: drop_ins)
  end

  def new(conn, _params) do
    changeset = Classes.change_drop_in(%DropIn{})
    classes = Classes.list_classes()
    students = Classes.list_students_without_referrers()

    render(
      conn,
      "new.html",
      changeset: changeset,
      classes: classes,
      students: students
    )
  end

  def create(conn, %{"drop_in" => drop_in_params}) do
    case Classes.create_drop_in(drop_in_params) do
      {:ok, drop_in} ->
        conn
        |> put_flash(:info, "Drop in created successfully.")
        |> redirect(to: Routes.drop_in_path(conn, :show, drop_in))

      {:error, %Ecto.Changeset{} = changeset} ->
        classes = Classes.list_classes()
        students = Classes.list_students_without_referrers()

        render(
          conn,
          "new.html",
          changeset: changeset,
          classes: classes,
          students: students
        )
    end
  end

  def show(conn, %{"id" => id}) do
    drop_in = Classes.get_drop_in!(id)
    render(conn, "show.html", drop_in: drop_in)
  end

  def edit(conn, %{"id" => id}) do
    drop_in = Classes.get_drop_in!(id)
    classes = Classes.list_classes()
    students = Classes.list_students_without_referrers()
    changeset = Classes.change_drop_in(drop_in)

    render(
      conn,
      "edit.html",
      drop_in: drop_in,
      changeset: changeset,
      classes: classes,
      students: students
    )
  end

  def update(conn, %{"id" => id, "drop_in" => drop_in_params}) do
    drop_in = Classes.get_drop_in!(id)

    case Classes.update_drop_in(drop_in, drop_in_params) do
      {:ok, drop_in} ->
        conn
        |> put_flash(:info, "Drop in updated successfully.")
        |> redirect(to: Routes.drop_in_path(conn, :show, drop_in))

      {:error, %Ecto.Changeset{} = changeset} ->
        classes = Classes.list_classes()
        students = Classes.list_students_without_referrers()

        render(
          conn,
          "edit.html",
          drop_in: drop_in,
          changeset: changeset,
          classes: classes,
          students: students
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    drop_in = Classes.get_drop_in!(id)
    {:ok, _drop_in} = Classes.delete_drop_in(drop_in)

    conn
    |> put_flash(:info, "Drop in deleted successfully.")
    |> redirect(to: Routes.drop_in_path(conn, :index))
  end
end
