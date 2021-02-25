defmodule Assisi.Repo.Migrations.CreateStudents do
  use Ecto.Migration

  def change do
    create table(:students) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string

      timestamps()
    end

    create unique_index(:students, [:first_name, :last_name])
  end
end
