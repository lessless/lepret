defmodule Lepret.Domain.EventStore do
  alias Lepret.Domain.EventStore.Checkpoint
  alias Lepret.Domain.EventStore.StreamMetadata
  alias Lepret.Domain.EventStore.ConversionTools

  defmodule SpearClient do
    use Spear.Client, otp_app: :lepret
  end

  @events_namespace Lepret.Domain.Event

  def load(decider, id) do
    stream_metadata = StreamMetadata.new(decider, id)
    raw_events = read_all_events(stream_metadata.stream_name)
    {Enum.map(raw_events, &deserialise!/1), StreamMetadata.current_revision(stream_metadata, raw_events)}
  end

  def publish(events, %StreamMetadata{} = stream_metadata) do
    events
    |> to_spear_events()
    |> SpearClient.append(stream_metadata.stream_name, expect: stream_metadata.current_revision)
  end

  def publish(decider, id, expected_revision, events) do
    publish(events, StreamMetadata.new(decider, id, expected_revision))
  end

  defp to_spear_events(events) do
    Enum.map(events, fn event -> Spear.Event.new(ConversionTools.module_name(event), event) end)
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
    raw_event.type in Enum.map(events_of_interest, &ConversionTools.module_name/1)
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

  defp read_all_events(stream_name) do
    stream_name
    |> SpearClient.stream!()
    |> Enum.into([])
  end
end
