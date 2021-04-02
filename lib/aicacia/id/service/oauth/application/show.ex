defmodule Aicacia.Id.Service.OAuth.Application.Show do
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
      Repo.get!(Model.OAuth.Application, command.id)
    end)
  end
end
