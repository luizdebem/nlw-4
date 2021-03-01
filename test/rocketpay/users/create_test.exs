defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase
  alias Rocketpay.Users.Create
  alias Rocketpay.User

  describe "call/1" do
    test "when all params are valid, return an user" do
      params = %{
        name: "Rafael",
        password: "12345678",
        nickname: "camarda",
        email: "rafael@banana.com",
        age: 27
      }

      {:ok, %User{id: user_id}} = Create.call(params)
      user = Repo.get(User, user_id)

      # ^ PIN Operator, evita que variável seja "atribuída" no caso user_id
      assert %User{name: "Rafael", age: 27, id: ^user_id} = user
    end

    test "when there are invalid params, returns an error" do
      params = %{
        name: "Rafael",
        nickname: "camarda",
        email: "rafael@banana.com",
        age: 15
      }

      {:error, changeset} = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
