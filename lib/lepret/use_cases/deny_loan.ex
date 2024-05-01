defmodule Lepret.UseCases.DenyLoan do
  alias Lepret.Domain.Commands.DenyLoan
  alias Lepret.Domain.LoanRequest
  alias Lepret.Domain.EventStore

  def run(%DenyLoan{} = command) do
    {events, stream_metadata} = EventStore.load(LoanRequest, command.id)
    loan_request = LoanRequest.evolve(events) |> IO.inspect(label: "EVOLVED LoanRequest")

    changes = LoanRequest.decide(loan_request, command)
    :ok = EventStore.publish(changes, stream_metadata)
  end
end
