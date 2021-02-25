defmodule AssisiWeb.SeriesController do
  use AssisiWeb, :controller

  alias Assisi.Classes
  alias Assisi.Classes.Student
  alias Assisi.Classes.Class
  alias Assisi.Classes.Series
  alias Assisi.Repo

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
    series = Classes.list_series()
    render(conn, "index.html", series: series)
  end

  def new(conn, _params) do
    changeset = Classes.change_series(%Series{})
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

  def create(conn, %{"series" => series_params}) do
    case Classes.create_series(series_params) do
      {:ok, series} ->
        conn
        |> put_flash(:info, "Series created successfully.")
        |> redirect(to: Routes.series_path(conn, :show, series))

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
    series = Classes.get_series!(id)
    render(conn, "show.html", series: series)
  end

  def edit(conn, %{"id" => id}) do
    series = Classes.get_series!(id)
    classes = Classes.list_classes()
    students = Classes.list_students_without_referrers()
    changeset = Classes.change_series(series)

    render(
      conn,
      "edit.html",
      series: series,
      changeset: changeset,
      classes: classes,
      students: students
    )
  end

  def update(conn, %{"id" => id, "series" => series_params}) do
    series = Classes.get_series!(id)

    case Classes.update_series(series, series_params) do
      {:ok, series} ->
        conn
        |> put_flash(:info, "Series updated successfully.")
        |> redirect(to: Routes.series_path(conn, :show, series))

      {:error, %Ecto.Changeset{} = changeset} ->
        classes = Classes.list_classes()
        students = Classes.list_students_without_referrers()

        render(
          conn,
          "edit.html",
          series: series,
          changeset: changeset,
          classes: classes,
          students: students
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    series = Classes.get_series!(id)
    {:ok, _series} = Classes.delete_series(series)

    conn
    |> put_flash(:info, "Series deleted successfully.")
    |> redirect(to: Routes.series_path(conn, :index))
  end
end
