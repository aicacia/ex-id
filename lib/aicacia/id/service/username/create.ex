defmodule Aicacia.Id.Service.Username.Create do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  schema "" do
    belongs_to(:user, Model.User, type: :binary_id)
    field(:username, :string)
  end

  @username_regex ~r/[a-zA-Z0-9\-_]+/i

  def username_regex, do: @username_regex

  def changeset(%{} = attrs) do
    %Service.Username.Create{}
    |> cast(attrs, [:user_id, :username])
    |> validate_required([:user_id, :username])
    |> validate_format(:username, @username_regex)
    |> unique_constraint(:username)
    |> foreign_key_constraint(:user_id)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      %Model.Username{}
      |> cast(
        %{
          user_id: command.user_id,
          username: command.username
        },
        [:user_id, :username]
      )
      |> foreign_key_constraint(:user_id)
      |> unique_constraint(:username)
      |> Repo.insert!()
    end)
  end
end
