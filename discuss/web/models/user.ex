defmodule Discuss.User do
  use Discuss.Web, :model

  @derive {Poison.Encoder, only: [:name]}
  schema "users" do
    field(:email, :string)
    field(:provider, :string)
    field(:token, :string)
    field(:name, :string)
    field(:nickname, :string)

    has_many(:topics, Discuss.Topic)
    has_many(:comments, Discuss.Comment)

    timestamps()
  end

  def changeset(record, params) do
    record
    |> cast(params, [:email, :provider, :token, :name, :nickname])
    |> validate_required([:email, :provider, :token, :name, :nickname])
  end
end
