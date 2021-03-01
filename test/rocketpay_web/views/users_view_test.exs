defmodule RocketpayWeb.UsersViewTest do
  alias Rocketpay.Account
  alias Rocketpay.User

  import Phoenix.View

  use RocketpayWeb.ConnCase

  test "renders create.json" do
    params = %{
      name: "Rafael",
      password: "12345678",
      nickname: "camarda",
      email: "rafael@banana.com",
      age: 27
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(params)

    response = render(RocketpayWeb.UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{balance: Decimal.new("0.00"), id: account_id},
        id: user_id,
        name: "Rafael",
        nickname: "camarda"
      }
    }

    assert expected_response == response
  end
end
