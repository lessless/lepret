defmodule Lepret.Domain.Commands.DenyLoan do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, []}
  embedded_schema do
  end

  def build(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:id])
    |> validate_required([:id])
    |> apply_action(:build)
  end
end
