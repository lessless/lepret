defmodule Lepret.UseCases.LoanRequest do
  alias Lepret.Commands.RequestLoan
  alias Lepret.CreditScoreApiClient
  alias Lepret.LoanRequest
  alias Lepret.EventStore

  def run(%RequestLoan{} = command) do
    {:ok, credit_score} = CreditScoreApiClient.for(command.national_id)
    command = RequestLoan.enrich_with(command, credit_score)
    changes = LoanRequest.decide(command)
    :ok = EventStore.publish(LoanRequest, command.id, :empty, changes)
  end
end
