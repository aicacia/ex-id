defmodule Aicacia.Id.Service.OAuth.AccessGrant.Delete do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Repo

  schema "" do
  end

  def changeset(%{} = attrs) do
    %__MODULE__{}
    |> cast(attrs, [:id])
    |> validate_required([:id])
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      application = Repo.get!(Model.OAuth.AccessGrant, command.id)
      Repo.delete!(application)
      application
    end)
  end
end
