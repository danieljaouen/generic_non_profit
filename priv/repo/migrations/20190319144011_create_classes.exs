defmodule Assisi.Repo.Migrations.CreateClasses do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :recurrent_or_one_time, :string
      add :start_date, :date
      add :end_date, :date
      add :class_date, :date
      add :drop_in_cost, :integer

      timestamps()
    end
  end
end
