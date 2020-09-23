defmodule Aicacia.User.Service.User.Show do
  use Aicacia.Handler
  import Ecto.Query

  alias Aicacia.User.Model
  alias Aicacia.User.Service
  alias Aicacia.User.Repo

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "" do
  end

  def changeset(%{} = params) do
    %Service.User.Show{}
    |> cast(params, [:id])
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      from(u in Model.User,
        where: u.id == ^command.id,
        preload: [:emails, :password]
      )
      |> Repo.one!()
    end)
  end
end
