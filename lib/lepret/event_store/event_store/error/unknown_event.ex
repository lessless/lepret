defmodule Lepret.EventStore.Error.UnknownEvent do
  defexception [:message, :payload]
end
