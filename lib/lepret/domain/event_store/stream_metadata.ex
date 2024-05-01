defmodule Lepret.Domain.EventStore.StreamMetadata do
  alias Lepret.Domain.EventStore.StreamMetadata
  alias Lepret.Domain.EventStore.ConversionTools
  @enforce_keys [:stream_name]
  defstruct [:stream_name, :current_revision]

  def new(decider, id) do
    %__MODULE__{
      stream_name: stream_name_for(decider, id)
    }
  end

  def new(decider, id, current_revision) do
    %__MODULE__{
      stream_name: stream_name_for(decider, id),
      current_revision: current_revision
    }
  end

  defp stream_name_for(decider, id) do
    "#{ConversionTools.module_name(decider)}:#{id}"
  end

  def current_revision(%StreamMetadata{} = stream_metadata, raw_events) when is_list(raw_events) do
    Map.put(stream_metadata, :current_revision, List.last(raw_events).metadata.stream_revision)
  end
end
