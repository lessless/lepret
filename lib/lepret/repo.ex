defmodule Lepret.Repo do
  use Ecto.Repo,
    otp_app: :lepret,
    adapter: Ecto.Adapters.SQLite3
end
