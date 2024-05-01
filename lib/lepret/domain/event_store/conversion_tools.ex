defmodule Lepret.Domain.EventStore.ConversionTools do
  def module_name(struct) when is_map(struct) do
    struct
    |> Map.get(:__struct__)
    |> module_name()
  end

  def module_name(module) when is_atom(module) do
    module
    |> Atom.to_string()
    |> String.split(".")
    |> List.last()
  end
end
