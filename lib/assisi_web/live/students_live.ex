defmodule AssisiWeb.StudentsLive do
  use Phoenix.LiveView

  import Ecto.Query

  alias Assisi.Repo
  alias Assisi.Classes
  alias Assisi.Classes.Student

  def mount(_session, socket) do
    {
      :ok,
      assign(
        socket,
        %{
          students: Classes.list_students_with_referrers()
        }
      )
    }
  end

  def render(assigns) do
    AssisiWeb.StudentView.render("index.html", assigns)
  end

  def handle_event("search", %{"q" => search_string}, socket) do
    split_string = search_string |> String.split()
    search_string = "%#{search_string}%"

    strings = [
      split_string |> Enum.at(0),
      split_string |> Enum.slice(1..-1) |> Enum.join(" "),
      split_string |> Enum.at(-1),
      split_string |> Enum.slice(0..-2) |> Enum.join(" ")
    ]

    strings = Enum.filter(strings, fn string -> string && string != "" end)
    strings = Enum.map(strings, fn string -> "%#{string}%" end)

    query =
      case length(strings) do
        0 ->
          from(student in Student,
            preload: [:referrer]
          )

        2 ->
          from(student in Student,
            where:
              ilike(student.first_name, ^Enum.at(strings, 0)) or
                ilike(student.last_name, ^Enum.at(strings, 1)) or
                ilike(student.email, ^search_string),
            preload: [:referrer]
          )

        4 ->
          from(student in Student,
            where:
              (ilike(student.first_name, ^Enum.at(strings, 0)) and
                 ilike(student.last_name, ^Enum.at(strings, 1))) or
                (ilike(student.first_name, ^Enum.at(strings, 2)) and
                   ilike(student.last_name, ^Enum.at(strings, 3))),
            preload: [:referrer]
          )
      end

    students = query |> Repo.all()

    {:noreply, assign(socket, students: students)}
  end
end
