defmodule LepretWeb.LoanRequestLive.Index do
  use LepretWeb, :live_view

  alias Lepret.Commands.RequestLoan, as: RequestLoanCommand

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Loan request")
    |> assign(:loan_request, RequestLoanCommand.build())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Loan requests")
    |> assign(:loan_request, nil)
  end

  @impl true
  def handle_info({LepretWeb.LoanRequestLive.FormComponent, {:saved, loan_request}}, socket) do
    {:noreply, stream_insert(socket, :loan_requests, loan_request)}
  end
end
