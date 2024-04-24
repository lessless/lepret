defmodule Lepret.EventStore do
  defmodule SpearClient do
    use Spear.Client, otp_app: :lepret
  end
end
