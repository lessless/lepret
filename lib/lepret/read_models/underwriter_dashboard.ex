defmodule Lepret.ReadModel.UnderwriterDashboard do
  use Ecto.Schema
  import Ecto.Changeset
  alias LepretWeb.Endpoint
  alias Lepret.Domain.Event.ManualReviewRequired
  alias Lepret.Repo

  @primary_key {:id, :binary_id, []}
  schema "underwriter_dashboard" do
    field :name, :string
    field :amount, :integer
    field :national_id, :string
    field :credit_score, :integer
    field :decision, Ecto.Enum, values: [:approved, :denied]

    timestamps()
  end

  def consume!(%ManualReviewRequired{} = event) do
    event
    |> Map.from_struct()
    |> Map.put(:credit_score, event.credit_score.score)
    |> create!()
    |> broadcast("new_loan_request_for_review")
  end

  defp create!(params) do
    %__MODULE__{}
    |> cast(params, [:id, :amount, :name, :national_id, :credit_score])
    |> validate_required([:id, :amount, :name, :national_id, :credit_score])
    |> Repo.insert!()
  end

  def list_loan_requests() do
    Repo.all(__MODULE__)
  end

  def topic() do
    Atom.to_string(__MODULE__)
  end

  defp broadcast(payload, event) do
    Endpoint.broadcast(topic(), event, payload)
  end
end
