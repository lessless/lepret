defmodule Lepret.Repo.Migrations.CreateUnderwriterDashboard do
  use Ecto.Migration

  def change do
    create table("underwriter_dashboard", primary_key: [name: :id, type: :binary_id]) do
      add :name, :string, null: false
      add :amount, :integer, null: false
      add :national_id, :string, null: false
      add :credit_score, :integer, null: false
      add :decision, :string

      timestamps()
    end
  end
end
