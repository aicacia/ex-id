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
  end
end
