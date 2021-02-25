defmodule Assisi.Repo.Migrations.AddMaxUsesAndCurrentUsesToSeries do
  use Ecto.Migration

  def change do
    alter table(:series) do
      add :max_uses, :integer, default: 8
      add :current_uses, :integer, default: 0
    end
  end
end
