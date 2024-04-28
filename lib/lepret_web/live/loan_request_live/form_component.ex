defmodule LepretWeb.LoanRequestLive.FormComponent do
  alias Lepret.UseCases
  use LepretWeb, :live_component

  alias Lepret.Domain.Commands.RequestLoan, as: RequestLoanCommand

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage loan_request records in your database.</:subtitle>
      </.header>

      <.simple_form for={@form} id="loan_request-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:amount]} type="number" label="Amount" />
        <.input field={@form[:national_id]} type="text" label="National ID (six numbers and two letters, e.g. 123456aa)" />
        <:actions>
          <.button phx-disable-with="Requesting...">Request Loan</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    changeset = RequestLoanCommand.changeset()

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"request_loan" => request_loan_params}, socket) do
    changeset =
      request_loan_params
      |> RequestLoanCommand.changeset()
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"request_loan" => request_loan_params}, socket) do
    case RequestLoanCommand.build(request_loan_params) do
      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}

      {:ok, command} ->
        save_loan_request(socket, command)
    end
  end

  defp save_loan_request(socket, command) do
    case UseCases.LoanRequest.run(command) do
      :ok ->
        {:noreply,
         socket
         |> put_flash(:info, "Loan successfully requested")
         |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
