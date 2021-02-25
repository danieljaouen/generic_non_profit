defmodule Assisi.Repo.Migrations.CreateSeries do
  use Ecto.Migration

  def change do
    create table(:series) do
      add :timeslot, :string
      add :class_id, references(:classes, on_delete: :nothing)
      add :student_id, references(:students, on_delete: :nothing)

      timestamps()
    end

    create index(:series, [:class_id])
    create index(:series, [:student_id])
  end
end
