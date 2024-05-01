defmodule Lepret.Domain.LoanRequest do
  use Ecto.Schema
  alias Lepret.Domain.Commands.RequestLoan
  alias Lepret.Domain.Commands.DenyLoan
  alias Lepret.Domain.Event.LoanRequested
  alias Lepret.Domain.Event.AutoApproved
  alias Lepret.Domain.Event.AutoDenied
  alias Lepret.Domain.Event.ManualReviewRequired
  alias Lepret.Domain.Event.ManuallyDenied

  @primary_key {:id, :binary_id, []}
  embedded_schema do
    field :name, :string
    field :amount, :integer
    field :national_id, :string
    field :credit_score, :map
    field :status, Ecto.Enum, values: [:auto_approved, :auto_denied, :manual_review_required]
  end

  def decide(%RequestLoan{} = command) do
    loan_requested = %LoanRequested{
      id: command.id,
      name: command.name,
      amount: command.amount,
      national_id: command.national_id,
      credit_score: command.credit_score
    }

    loan_request_review_decision =
      cond do
        command.credit_score.score >= 7 ->
          %AutoApproved{id: command.id}

        command.credit_score.score <= 4 ->
          %AutoDenied{id: command.id}

        true ->
          %ManualReviewRequired{
            id: command.id,
            name: command.name,
            amount: command.amount,
            national_id: command.national_id,
            credit_score: command.credit_score
          }
      end

    [loan_requested, loan_request_review_decision]
  end

  def decide(%__MODULE__{status: :manual_review_required}, %DenyLoan{} = command) do
    [%ManuallyDenied{id: command.id}]
  end

  def evolve(events) do
    List.foldl(events, initial_state(), &evolve/2)
  end

  def evolve(%LoanRequested{} = event, %__MODULE__{id: nil, status: nil} = state) do
    %{
      state
      | id: event.id,
        name: event.name,
        amount: event.amount,
        national_id: event.national_id,
        credit_score: event.credit_score
    }
  end

  def evolve(%ManualReviewRequired{} = _event, %__MODULE__{status: nil} = state) do
    %{state | status: :manual_review_required}
  end

  defp initial_state() do
    %__MODULE__{}
  end
end
