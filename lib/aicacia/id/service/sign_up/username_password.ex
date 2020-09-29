defmodule Aicacia.Id.Service.SignUp.UsernameAndPassword do
  use Aicacia.Handler
  import Ecto.Changeset

  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  schema "" do
    field(:username, :string)
    field(:password, :string)
  end

  def changeset(%{} = attrs) do
    %Service.SignUp.UsernameAndPassword{}
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      user = %{} |> Service.User.Create.new!() |> Service.User.Create.handle!()

      _username =
        %{user_id: user.id, username: command.username, primary: true}
        |> Service.Username.Create.new!()
        |> Service.Username.Create.handle!()

      _password =
        %{user_id: user.id, password: command.password}
        |> Service.Password.Create.new!()
        |> Service.Password.Create.handle!()

      Service.User.Show.handle!(%{id: user.id})
    end)
  end
end
