defmodule Rocketpay.Users.Create do
  alias Ecto.Multi
  alias Rocketpay.{Repo, User, Account}

  def call(params) do
    # É uma transação, ler docs depois
    Multi.new()
    |> Multi.insert(:create_user, User.changeset(params))
    |> Multi.run(:create_account, fn repo, %{create_user: user} -> insert_account(repo, user) end)
    |> Multi.run(:preload_data, fn repo, %{create_user: user} -> preload_data(repo, user) end)
    |> run_transaction()
  end

  defp insert_account(repo, user) do
    user.id
    |> account_changeset()
    |> repo.insert()
  end

  defp preload_data(repo, user) do
    {:ok, repo.preload(user, :account)}
  end

  defp account_changeset(user_id) do
    params = %{user_id: user_id, balance: "0.00"}
    Account.changeset(params)
  end

  defp run_transaction(multi) do
    case Repo.transaction(multi) do # Case: pattern matching de funções, ler comentários abaixo:
      {:error, _operation, reason, _changes} -> {:error, reason} # case dê pattern matching aqui
      {:ok, %{preload_data: user}} -> {:ok, user} # case dê pattern matching aqui..
    end
  end
end
