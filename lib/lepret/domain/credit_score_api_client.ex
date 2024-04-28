defmodule Lepret.Domain.CreditScoreApiClient do
  alias Lepret.Domain.CreditScore

  def for(national_id) do
    _latency = Process.sleep(100)
    {:ok, CreditScore.new(national_id, predefined_credit_scores(national_id), DateTime.utc_now())}
  end

  defp predefined_credit_scores(national_id) do
    case national_id do
      "999999aa" -> 9
      "666666aa" -> 6
      "555555aa" -> 5
      "111111aa" -> 1
      _ -> Enum.random(1..10)
    end
  end
end
