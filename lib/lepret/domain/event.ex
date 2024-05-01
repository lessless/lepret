defmodule Lepret.Domain.Event do
  defmodule LoanRequested do
    @derive Jason.Encoder
    use Ecto.Schema
    import Ecto.Changeset
    alias Lepret.Domain.CreditScore

    @primary_key {:id, :binary_id, []}
    embedded_schema do
      field :name, :string
      field :amount, :integer
      field :national_id, :string
      embeds_one :credit_score, CreditScore
    end

    def deserialise!(serialised_body) do
      %__MODULE__{}
      |> cast(serialised_body, [:id, :name, :amount, :national_id])
      |> validate_required([:id, :name, :amount, :national_id])
      |> cast_embed(:credit_score, required: true)
      |> apply_action!(:deserialise)
    end
  end

  defmodule AutoApproved do
    @derive Jason.Encoder
    use Ecto.Schema
    @primary_key {:id, :binary_id, []}
    embedded_schema do
    end
  end

  defmodule AutoDenied do
    @derive Jason.Encoder
    use Ecto.Schema
    @primary_key {:id, :binary_id, []}
    embedded_schema do
    end
  end

  defmodule ManualReviewRequired do
    use Ecto.Schema
    import Ecto.Changeset
    alias Lepret.Domain.CreditScore

    @derive Jason.Encoder
    @primary_key {:id, :binary_id, []}
    embedded_schema do
      field :name, :string
      field :amount, :integer
      field :national_id, :string
      embeds_one :credit_score, CreditScore
    end

    def deserialise!(serialised_body) do
      %__MODULE__{}
      |> cast(serialised_body, [:id, :name, :amount, :national_id])
      |> validate_required([:id, :name, :amount, :national_id])
      |> cast_embed(:credit_score, required: true)
      |> apply_action!(:deserialise)
    end
  end

  defmodule ManuallyDenied do
    @derive Jason.Encoder
    use Ecto.Schema
    @primary_key {:id, :binary_id, []}
    embedded_schema do
    end
  end
end
