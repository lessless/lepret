defmodule LepretWeb.UnderwriterDashboardLive.Index do
  alias LepretWeb.Endpoint
  use LepretWeb, :live_view

  alias Lepret.ReadModel.UnderwriterDashboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :loan_requests, UnderwriterDashboard.list_loan_requests())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    if connected?(socket) do
      Endpoint.subscribe(UnderwriterDashboard.topic())
    end

    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Pending loan requests")
  end

  @impl true
  def handle_info(%{event: "new_loan_request_for_review", payload: new_loan_request}, socket) do
    {:noreply, stream_insert(socket, :loan_requests, new_loan_request)}
  end
end
