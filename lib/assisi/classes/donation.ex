defmodule Assisi.Classes.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :amount, :decimal
    field :class_date, :date
    belongs_to :class, Assisi.Classes.Class
    belongs_to :student, Assisi.Classes.Student

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:class_id, :student_id, :amount, :class_date])
    |> validate_required([:class_id, :student_id, :amount, :class_date])
  end
end
