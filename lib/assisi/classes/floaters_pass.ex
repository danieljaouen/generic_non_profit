defmodule Assisi.Classes.FloatersPass do
  use Ecto.Schema
  import Ecto.Changeset

  alias Assisi.Classes.Student

  schema "floaters_passes" do
    field :current_uses, :integer, default: 0
    field :expiration_date, :date
    field :max_uses, :integer, default: 5
    belongs_to :student, Student

    timestamps()
  end

  @doc false
  def changeset(floaters_pass, attrs) do
    floaters_pass
    |> cast(attrs, [:student_id, :expiration_date, :max_uses, :current_uses])
    |> validate_required([:student_id, :expiration_date, :max_uses, :current_uses])
  end
end
