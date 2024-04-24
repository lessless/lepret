defmodule LepretWeb.LoanRequestLive.FormComponent do
  use LepretWeb, :live_component

  alias Lepret.Commands.RequestLoan, as: RequestLoanCommand

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

      {:ok, _command} ->
        # we will place valid command on the next step
        {:noreply, socket}
    end
  end

  # defp save_loan_request(command) do
  #   case LoanRequests.create_loan_request(loan_request_params) do
  #     {:ok, loan_request} ->
  #       notify_parent({:saved, loan_request})

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Loan request created successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign_form(socket, changeset)}
  #   end
  # end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
