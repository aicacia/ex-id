defmodule Aicacia.Id.Service.User.Update do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Repo
  alias Aicacia.Id.Service

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
    field(:username, :string, null: false)
  end

  def changeset(%{} = params) do
    %__MODULE__{}
    |> cast(params, [:id, :username])
    |> validate_format(:username, Service.User.Create.username_regex())
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      Repo.get!(Model.User, command.id)
      |> cast(
        command,
        [:username]
      )
      |> unique_constraint(:username)
      |> Repo.update!()
      |> Repo.preload([:emails, :password])
    end)
  end
end
