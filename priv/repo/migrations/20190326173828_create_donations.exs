defmodule Assisi.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :amount, :decimal
      add :class_date, :date
      add :class_id, references(:classes, on_delete: :nothing)
      add :student_id, references(:students, on_delete: :nothing)

      timestamps()
    end

    create index(:donations, [:class_id])
    create index(:donations, [:student_id])
  end
end
