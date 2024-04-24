defmodule Lepret.UseCases.LoanRequest do
  alias Lepret.Commands.RequestLoan
  alias Lepret.CreditScoreApiClient

  def run(%RequestLoan{} = command) do
    {:ok, credit_score} = CreditScoreApiClient.for(command.national_id)
    _command = RequestLoan.enrich_with(command, credit_score)
    :ok
  end
end
