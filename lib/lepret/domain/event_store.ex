defmodule Lepret.Domain.EventStore do
  alias Lepret.Domain.EventStore.Checkpoint

  defmodule SpearClient do
    use Spear.Client, otp_app: :lepret
  end

  @events_namespace Lepret.Domain.Event

  def publish(decider, id, expected_revision, events) do
    events
    |> to_spear_events()
    |> SpearClient.append(stream_name_for(decider, id), expect: expected_revision)
  end

  defp to_spear_events(events) do
    Enum.map(events, fn event -> Spear.Event.new(module_name(event), event) end)
  end

  defp stream_name_for(decider, id) do
    "#{module_name(decider)}:#{id}"
  end

  defp module_name(struct) when is_map(struct) do
    struct
    |> Map.get(:__struct__)
    |> module_name()
  end

  defp module_name(module) when is_atom(module) do
    module
    |> Atom.to_string()
    |> String.split(".")
    |> List.last()
  end

  def catchup_subscription(subscriber_pid, checkpoint_name) do
    SpearClient.subscribe(
      subscriber_pid,
      :all,
      from: Checkpoint.current(checkpoint_name),
      filter: Spear.Filter.exclude_system_events()
    )
  end

  def event_type_in?(%Spear.Event{} = raw_event, events_of_interest) do
    raw_event.type in Enum.map(events_of_interest, &module_name/1)
  end

  def event_type_in?(_checkpoint, _events_of_interest) do
    false
  end

  def deserialise!(%Spear.Event{} = raw_event) do
    module_name = Module.concat(@events_namespace, raw_event.type)
    module_name.deserialise!(raw_event.body)
  end

  def update_checkpoint!(checkpoint_name, %Spear.Event{} = raw_event) do
    Checkpoint.update!(checkpoint_name, raw_event.metadata.commit_position)
  end
end
