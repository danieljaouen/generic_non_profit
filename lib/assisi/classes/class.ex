defmodule Assisi.Classes.Class do
  use Ecto.Schema
  import Ecto.Changeset

  schema "classes" do
    field :name, :string
    field :class_date, :date
    field :drop_in_cost, :decimal
    field :end_date, :date
    field :recurrent_or_one_time, :string
    field :start_date, :date

    timestamps()
  end

  @doc false
  def changeset(class, attrs) do
    class
    |> cast(attrs, [
      :name,
      :recurrent_or_one_time,
      :start_date,
      :end_date,
      :class_date,
      :drop_in_cost
    ])
    |> validate_required([
      :name,
      :recurrent_or_one_time,
      :start_date,
      :end_date,
      :class_date,
      :drop_in_cost
    ])
  end
end
