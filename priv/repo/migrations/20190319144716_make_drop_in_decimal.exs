defmodule Assisi.Repo.Migrations.MakeDropInDecimal do
  use Ecto.Migration

  def change do
    alter table(:classes) do
      modify :drop_in_cost, :decimal
    end
  end
end
