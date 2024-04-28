defmodule Lepret.Domain.Event do
  defmodule LoanRequested do
    @derive Jason.Encoder
    use Ecto.Schema
    @primary_key {:id, :binary_id, []}
    embedded_schema do
      field :name, :string
      field :amount, :integer
      field :national_id, :string
      field :credit_score, :map
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
    @derive Jason.Encoder
    use Ecto.Schema
    @primary_key {:id, :binary_id, []}
    embedded_schema do
      field :name, :string
      field :amount, :integer
      field :national_id, :string
      field :credit_score, :map
    end
  end
end
