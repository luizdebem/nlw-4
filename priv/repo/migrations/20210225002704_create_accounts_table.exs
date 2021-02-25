defmodule Rocketpay.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table :accounts do
      add :balance, :decimal # importante usar decimal (e não float): o ecto utiliza decimal especialmente para valores monetários.
      add :user_id, references(:users, type: :binary_id)

      timestamps()
    end

    create constraint(:accounts, :balance_must_be_positive_or_zero, check: "balance >= 0")
  end
end
