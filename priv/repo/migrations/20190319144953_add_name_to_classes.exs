defmodule Assisi.Repo.Migrations.AddNameToClasses do
  use Ecto.Migration

  def change do
    alter table(:classes) do
      add :name, :string
    end
  end
end
