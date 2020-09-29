defmodule Aicacia.Id.Model.Username do
  use Ecto.Schema

  alias Aicacia.Id.Model

  schema "usernames" do
    belongs_to(:user, Model.User, type: :binary_id)

    field(:username, :string, null: false)

    timestamps(type: :utc_datetime)
  end
end
