defmodule Assisi.Repo.Migrations.CreateFloatersPasses do
  use Ecto.Migration

  def change do
    create table(:floaters_passes) do
      add :expiration_date, :date
      add :max_uses, :integer, default: 5
      add :current_uses, :integer, default: 0
      add :student_id, references(:students, on_delete: :nothing)

      timestamps()
    end

    create index(:floaters_passes, [:student_id])
  end
end
