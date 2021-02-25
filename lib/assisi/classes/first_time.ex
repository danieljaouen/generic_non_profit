defmodule Assisi.Classes.FirstTime do
  use Ecto.Schema
  import Ecto.Changeset

  alias Assisi.Classes.Student
  alias Assisi.Classes.Class

  schema "first_times" do
    field :date, :date
    field :timeslot, :string
    belongs_to :student, Student
    belongs_to :class, Class

    timestamps()
  end

  @doc false
  def changeset(first_time, attrs) do
    first_time
    |> cast(attrs, [:student_id, :class_id, :date, :timeslot])
    |> validate_required([:student_id, :class_id, :date, :timeslot])
  end
end
