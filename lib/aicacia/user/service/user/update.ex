defmodule Aicacia.User.Service.User.Update do
  use Aicacia.Handler

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
  end

  def changeset(%{} = params) do
    %Service.User.Update{}
    |> cast(params, [:id])
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    case Service.User.Show.handle(command) do
      {:ok, user} ->
        Repo.transaction(fn ->
          user
        end)

      error ->
        error
    end
  end
end
