defmodule Rocketpay.User do
  # Não é model, mas é tipo isso
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset

  # :binary_id = "717a8af3-61fa-4d90-81f3-529902058055" por exemplo
  @primary_key {:id, :binary_id, autogenerate: true}
  @required_params [:name, :age, :email, :password, :nickname]

  schema "users" do
    field :name, :string
    field :age, :integer
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :nickname, :string
    timestamps()
  end


  # 1 objetivo do changeset: validar dados
  # 2 objetivo: mapear dados pro schema
  def changeset(params) do
    %__MODULE__{}
      |> cast(params, @required_params)
      |> validate_required(@required_params)
      |> validate_length(:password, min: 8)
      |> validate_number(:age, greater_than_or_equal_to: 18)
      |> validate_format(:email, ~r/@/)
      |> unique_constraint([:email])
      |> unique_constraint([:nickname])
      |> put_password_hash()
  end

  # Recebendo um changeset válido e pegando a senha por pattern matching
  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    # Função change: tamo inserindo no changeset o compo password_hash (password_hash é o retorno do Bcrypt)
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
