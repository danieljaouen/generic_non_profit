defmodule Assisi.Repo do
  use Ecto.Repo,
    otp_app: :assisi,
    adapter: Ecto.Adapters.Postgres
end
