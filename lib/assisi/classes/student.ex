defmodule Assisi.Classes.Student do
  use Ecto.Schema
  import Ecto.Changeset

  alias Assisi.Classes.Series
  alias Assisi.Classes.DropIn
  alias Assisi.Classes.FloatersPass
  alias Assisi.Classes.FirstTime
  alias Assisi.Classes.Donation

  schema "students" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :credit, :decimal, default: 0

    belongs_to :referrer, Assisi.Classes.Student

    has_many :serieses, Series
    has_many :drop_ins, DropIn
    has_many :floaters_passes, FloatersPass
    has_many :first_times, FirstTime
    has_many :donations, Donation

    timestamps()
  end

  @doc false
  def changeset(student, attrs) do
    student
    |> cast(attrs, [:credit, :referrer_id, :first_name, :last_name, :email])
    |> validate_required([:first_name, :last_name])
    |> unique_constraint(:last_name, name: :students_first_name_last_name_index)
  end
end
