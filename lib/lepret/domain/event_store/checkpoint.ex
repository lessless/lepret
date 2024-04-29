defmodule Lepret.Domain.EventStore.Checkpoint do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lepret.Repo

  @primary_key {:name, :string, autogenerate: false}
  schema "read_model_checkpoints" do
    field :position, :integer

    timestamps()
  end

  def current(name) do
    checkpoint = get(name) || create(name)

    %Spear.Filter.Checkpoint{commit_position: checkpoint.position, prepare_position: checkpoint.position}
  end

  defp get(name) do
    Repo.get(__MODULE__, name)
  end

  def create(name) do
    Repo.insert!(%__MODULE__{name: name, position: 0})
  end

  def update!(name, position) do
    name
    |> get()
    |> change(%{position: position})
    |> Repo.update!()
  end
end
