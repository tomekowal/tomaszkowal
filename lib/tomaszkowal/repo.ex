defmodule Tomaszkowal.Repo do
  use Ecto.Repo,
    otp_app: :tomaszkowal,
    adapter: Ecto.Adapters.Postgres
end
