defmodule Assisi.Classes.DropIn do
  use Ecto.Schema
  import Ecto.Changeset

  alias Assisi.Classes.Class
  alias Assisi.Classes.Student

  schema "drop_ins" do
    field :date, :date
    field :paid, :boolean, default: false
    field :timeslot, :string
    belongs_to :class, Class
    belongs_to :student, Student

    timestamps()
  end

  @doc false
  def changeset(drop_in, attrs) do
    drop_in
    |> cast(attrs, [:student_id, :class_id, :date, :timeslot, :paid])
    |> validate_required([:student_id, :class_id, :date, :timeslot, :paid])
  end
end
