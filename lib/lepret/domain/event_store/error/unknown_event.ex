defmodule Lepret.Domain.EventStore.Error.UnknownEvent do
  defexception [:message, :payload]
end
