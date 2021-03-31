defmodule Aicacia.Id.Service.User.Update do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  @username_regex ~r/[a-zA-Z0-9\-_]+/i

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
    field(:username, :string, null: false)
  end

  def changeset(%{} = params) do
    %Service.User.Update{}
    |> cast(params, [:id, :username])
    |> validate_format(:username, @username_regex)
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
    end)
  end
end
