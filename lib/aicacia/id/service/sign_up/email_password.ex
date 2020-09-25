defmodule Aicacia.Id.Service.SignUp.EmailPassword do
  use Aicacia.Handler
  import Ecto.Changeset

  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  schema "" do
    field(:email, :string)
    field(:password, :string)
  end

  def changeset(%{} = attrs) do
    %Service.SignUp.EmailPassword{}
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      user = %{} |> Service.User.Create.new!() |> Service.User.Create.handle!()

      _email =
        %{user_id: user.id, email: command.email, primary: true}
        |> Service.Email.Create.new!()
        |> Service.Email.Create.handle!()

      _password =
        %{user_id: user.id, password: command.password}
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()

      Service.User.Show.handle!(%{id: user.id})
    end)
  end
end
