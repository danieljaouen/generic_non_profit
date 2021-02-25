defmodule AssisiWeb.FirstTimeController do
  use AssisiWeb, :controller

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Classes.FirstTime
  alias Assisi.Classes.Class
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
    first_times = Classes.list_first_times()
    render(conn, "index.html", first_times: first_times)
  end

  def new(conn, _params) do
    changeset = Classes.change_first_time(%FirstTime{})
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

  def create(conn, %{"first_time" => first_time_params}) do
    case Classes.create_first_time(first_time_params) do
      {:ok, first_time} ->
        conn
        |> put_flash(:info, "First time created successfully.")
        |> redirect(to: Routes.first_time_path(conn, :show, first_time))

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
    first_time = Classes.get_first_time!(id)
    render(conn, "show.html", first_time: first_time)
  end

  def edit(conn, %{"id" => id}) do
    first_time = Classes.get_first_time!(id)
    classes = Classes.list_classes()
    students = Classes.list_students_without_referrers()
    changeset = Classes.change_first_time(first_time)

    render(
      conn,
      "edit.html",
      first_time: first_time,
      changeset: changeset,
      classes: classes,
      students: students
    )
  end

  def update(conn, %{"id" => id, "first_time" => first_time_params}) do
    first_time = Classes.get_first_time!(id)

    case Classes.update_first_time(first_time, first_time_params) do
      {:ok, first_time} ->
        conn
        |> put_flash(:info, "First time updated successfully.")
        |> redirect(to: Routes.first_time_path(conn, :show, first_time))

      {:error, %Ecto.Changeset{} = changeset} ->
        classes = Classes.list_classes()
        students = Classes.list_students_without_referrers()

        render(
          conn,
          "edit.html",
          first_time: first_time,
          changeset: changeset,
          classes: classes,
          students: students
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    first_time = Classes.get_first_time!(id)
    {:ok, _first_time} = Classes.delete_first_time(first_time)

    conn
    |> put_flash(:info, "First time deleted successfully.")
    |> redirect(to: Routes.first_time_path(conn, :index))
  end
end
