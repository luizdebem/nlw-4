defmodule Rocketpay.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  # Pra rodar migration (criar tabela): mix ecto.migrate
  # Pra dropar O BANCO, mix ecto.drop - depois mix ecto.create

  def change do
    create table :users do
      # O ID é implícito, já vai ser gerado automaticamente, e por default é integer - mas trocamos isso lá no config/config.exs
      add :name, :string
      add :age, :integer
      add :email, :string
      add :password_hash, :string
      add :nickname, :string
      timestamps() # inserted_at, updated_at
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:nickname])
  end

  # essas duas funções definem o que vai acontecer na migração e no rollback, mas não é necessário
  # def up do
    # ...
  # end

  # def down do
    # ...
  # end
end
