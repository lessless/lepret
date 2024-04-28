defmodule Lepret.EventStore.Error.RevisionViolation do
  defexception [:message, :current, :expected]
end
