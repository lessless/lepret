defmodule Lepret.Commands.RequestLoan do
  use Ecto.Schema
  import Ecto.Changeset
  alias Lepret.CreditScore

  @primary_key {:id, :binary_id, []}
  embedded_schema do
    field :name, :string
    field :amount, :integer
    field :national_id, :string
    field :credit_score, :map
  end

  def build() do
    %__MODULE__{}
  end

  def build(attrs) do
    attrs
    |> changeset()
    |> put_change(:id, Ecto.UUID.generate())
    |> apply_action(:build)
  end

  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:name, :amount, :national_id])
    |> validate_required([:name, :amount, :national_id])
    |> validate_length(:name, min: 2)
    |> validate_number(:amount, greater_than: 0)
    |> validate_format(:national_id, ~r/^\d{6}[A-Za-z]{2}$/)
  end

  def enrich_with(%__MODULE__{} = command, %CreditScore{} = credit_score) do
    Map.put(command, :credit_score, credit_score)
  end
end
