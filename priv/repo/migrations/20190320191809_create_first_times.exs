defmodule Assisi.Repo.Migrations.CreateFirstTimes do
  use Ecto.Migration

  def change do
    create table(:first_times) do
      add :date, :date
      add :timeslot, :string
      add :student_id, references(:students, on_delete: :nothing)
      add :class_id, references(:classes, on_delete: :nothing)

      timestamps()
    end

    create index(:first_times, [:student_id])
    create index(:first_times, [:class_id])
  end
end
