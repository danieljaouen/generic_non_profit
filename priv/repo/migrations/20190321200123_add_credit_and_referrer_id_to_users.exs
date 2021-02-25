defmodule Assisi.Repo.Migrations.AddCreditAndReferrerIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:students) do
      add :credit, :decimal, default: 0
      add :referrer_id, references(:students, on_delete: :nothing)
    end

    create index(:students, [:referrer_id])
  end
end
