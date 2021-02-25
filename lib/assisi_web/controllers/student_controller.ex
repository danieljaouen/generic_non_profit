defmodule AssisiWeb.StudentController do
  use AssisiWeb, :controller

  alias Assisi.Repo
  alias Assisi.Classes
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
    students = Classes.list_students_with_referrers()
    render(conn, "index.html", students: students)
  end

  def new(conn, _params) do
    changeset = Classes.change_student(%Student{})
    students = Classes.list_students_without_referrers()
    render(conn, "new.html", changeset: changeset, students: students)
  end

  def create(conn, %{"student" => student_params}) do
    case Classes.create_student(student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student created successfully.")
        |> redirect(to: Routes.student_path(conn, :show, student))

      {:error, %Ecto.Changeset{} = changeset} ->
        students = Classes.list_students_without_referrers()
        render(conn, "new.html", changeset: changeset, students: students)
    end
  end

  def show(conn, %{"id" => id}) do
    student = Classes.get_student!(id)
    referrals = Classes.get_referrals(id)

    past_serieses =
      Enum.filter(
        student.serieses,
        fn series ->
          Timex.before?(series.class.class_date, Timex.now()) &&
            Timex.before?(series.class.end_date, Timex.now())
        end
      )

    current_serieses =
      Enum.filter(
        student.serieses,
        fn series ->
          !Timex.before?(series.class.class_date, Timex.now()) ||
            !Timex.before?(series.class.end_date, Timex.now())
        end
      )

    paid_drop_ins =
      Enum.filter(
        student.drop_ins,
        fn drop_in -> drop_in.paid end
      )

    unpaid_drop_ins =
      Enum.filter(
        student.drop_ins,
        fn drop_in -> !drop_in.paid end
      )

    unexpired_floaters_passes =
      Enum.filter(
        student.floaters_passes,
        fn floaters_pass ->
          Timex.before?(Timex.now(), floaters_pass.expiration_date)
        end
      )

    render(
      conn,
      "show.html",
      student: student,
      referrals: referrals,
      past_serieses: past_serieses,
      current_serieses: current_serieses,
      paid_drop_ins: paid_drop_ins,
      unpaid_drop_ins: unpaid_drop_ins,
      unexpired_floaters_passes: unexpired_floaters_passes
    )
  end

  def edit(conn, %{"id" => id}) do
    student = Classes.get_student!(id)
    students = Classes.list_students_without_referrers()
    changeset = Classes.change_student(student)

    render(
      conn,
      "edit.html",
      student: student,
      changeset: changeset,
      students: students
    )
  end

  def update(conn, %{"id" => id, "student" => student_params}) do
    student = Classes.get_student!(id)

    case Classes.update_student(student, student_params) do
      {:ok, student} ->
        conn
        |> put_flash(:info, "Student updated successfully.")
        |> redirect(to: Routes.student_path(conn, :show, student))

      {:error, %Ecto.Changeset{} = changeset} ->
        students = Classes.list_students_without_referrers()

        render(
          conn,
          "edit.html",
          student: student,
          changeset: changeset,
          students: students
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    student = Classes.get_student!(id)
    {:ok, _student} = Classes.delete_student(student)

    conn
    |> put_flash(:info, "Student deleted successfully.")
    |> redirect(to: Routes.student_path(conn, :index))
  end
end
