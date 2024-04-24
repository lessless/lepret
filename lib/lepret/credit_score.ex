defmodule Lepret.CreditScore do
  defstruct [:score, :national_id, :ts]

  def new(national_id, score, ts) do
    %__MODULE__{national_id: national_id, score: score, ts: ts}
  end
end
