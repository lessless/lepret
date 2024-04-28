defmodule Lepret.EventStore do
  defmodule SpearClient do
    use Spear.Client, otp_app: :lepret
  end

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
end
