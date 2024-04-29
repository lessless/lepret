defmodule Lepret.Repo.Migrations.CreateReadModelCheckpoints do
  use Ecto.Migration

  def change do
    create table("read_model_checkpoints", primary_key: false) do
      add :name, :string, primary_key: true
      add :position, :integer, null: false

      timestamps()
    end
  end
end
