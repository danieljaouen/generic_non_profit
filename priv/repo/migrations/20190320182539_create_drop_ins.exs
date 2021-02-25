defmodule Assisi.Repo.Migrations.CreateDropIns do
  use Ecto.Migration

  def change do
    create table(:drop_ins) do
      add :date, :date
      add :timeslot, :string
      add :paid, :boolean, default: false, null: false
      add :class_id, references(:classes, on_delete: :nothing)
      add :student_id, references(:students, on_delete: :nothing)

      timestamps()
    end

    create index(:drop_ins, [:class_id])
    create index(:drop_ins, [:student_id])
  end
end
