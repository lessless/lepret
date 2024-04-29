defmodule Lepret.Domain.CreditScore do
  use Ecto.Schema
  import Ecto.Changeset
  @derive Jason.Encoder
  @primary_key false
  embedded_schema do
    field :score, :integer
    field :national_id, :string
    field :ts, :utc_datetime
  end

  def new(national_id, score, ts) do
    %__MODULE__{national_id: national_id, score: score, ts: ts}
  end

  def changeset(credit_score \\ %__MODULE__{}, params) do
    credit_score
    |> cast(params, [:score, :national_id, :ts])
    |> validate_required([:score, :national_id, :ts])
  end
end
