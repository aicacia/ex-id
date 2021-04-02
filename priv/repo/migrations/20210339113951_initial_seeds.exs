defmodule Aicacia.Id.Repo.Migrations.CreateInitialSeeds do
  use Ecto.Migration

  alias Aicacia.Id.Service

  def change do
    execute(&execute_change/0)
  end

  def execute_change do
    admin_password = System.get_env("ADMIN_PASSWORD")
    url = System.get_env("URL")

    user =
      %{username: "admin", password: admin_password, password_confirmation: admin_password}
      |> Service.SignUp.UsernameAndPassword.new!()
      |> Service.SignUp.UsernameAndPassword.handle!()

    _application = %{owner_id: user.id, name: "Aicacia Id", redirect_uri: "#{url}/oauth/callback", scopes: "admin"}
      |> Service.OAuth.Application.Create.new!()
      |> Service.OAuth.Application.Create.handle!()
  end
end
