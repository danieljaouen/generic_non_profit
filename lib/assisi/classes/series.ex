defmodule Assisi.Classes.Series do
  use Ecto.Schema
  import Ecto.Changeset

  alias Assisi.Classes.Class
  alias Assisi.Classes.Student

  schema "series" do
    field :timeslot, :string
    field :max_uses, :integer, default: 8
    field :current_uses, :integer, default: 0
    belongs_to :class, Class
    belongs_to :student, Student

    timestamps()
  end

  @doc false
  def changeset(series, attrs) do
    series
    |> cast(attrs, [:max_uses, :current_uses, :timeslot, :student_id, :class_id])
    |> validate_required([:timeslot, :student_id, :class_id])
  end
end
