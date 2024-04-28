defmodule Lepret.Domain.LoanRequest do
  use Ecto.Schema
  alias Lepret.Domain.Commands.RequestLoan
  alias Lepret.Domain.Event.LoanRequested
  alias Lepret.Domain.Event.AutoApproved
  alias Lepret.Domain.Event.AutoDenied
  alias Lepret.Domain.Event.ManualReviewRequired

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
end
