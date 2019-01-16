defmodule Discuss.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:provider, :string)
      add(:token, :string)
      add(:name, :string)
      add(:nickname, :string)

      timestamps()
    end
  end
end
