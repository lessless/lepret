defmodule Lepret.ReadModel.UnderwriterDashboard.Subscription do
  use GenServer
  alias Lepret.Domain.EventStore
  alias Lepret.Domain.Event.ManualReviewRequired
  alias Lepret.ReadModel.UnderwriterDashboard
  alias Lepret.Repo

  def start_link(params) do
    GenServer.start_link(__MODULE__, params)
  end

  @impl GenServer
  def init(_) do
    {:ok, _subscription} = EventStore.catchup_subscription(self(), checkpoint_name())

    {:ok, nil}
  end

  @impl GenServer
  def handle_info(raw_event, state) do
    if EventStore.event_type_in?(raw_event, [ManualReviewRequired]) do
      {:ok, _} =
        Repo.transaction(fn ->
          event = EventStore.deserialise!(raw_event)
          UnderwriterDashboard.consume!(event)
          EventStore.update_checkpoint!(checkpoint_name(), raw_event)
        end)
    end

    {:noreply, state}
  end

  defp checkpoint_name() do
    Atom.to_string(__MODULE__)
  end
end
