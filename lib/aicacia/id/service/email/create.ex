defmodule Aicacia.Id.Service.Email.Create do
  use Aicacia.Handler

  alias Aicacia.Id.Model
  alias Aicacia.Id.Service
  alias Aicacia.Id.Repo

  @email_regex ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i

  schema "" do
    field(:user_id, :binary_id)
    field(:email, :string)
    field(:primary, :boolean)
  end

  def changeset(%{} = attrs) do
    %Service.Email.Create{}
    |> cast(attrs, [:user_id, :email, :primary])
    |> validate_required([:user_id, :email])
    |> validate_format(:email, @email_regex)
  end

  def handle(%{} = command) do
    Repo.run(fn ->
      email =
        %Model.Email{}
        |> cast(
          %{
            user_id: command.user_id,
            email: command.email,
            primary: Map.get(command, :primary, false)
          },
          [:user_id, :email, :primary]
        )
        |> foreign_key_constraint(:user_id)
        |> unique_constraint(:email)
        |> Repo.insert!()

      Service.Email.CreateConfirmationToken.handle!(%{user_id: email.user_id, email_id: email.id})

      email
    end)
  end

  def confirmation_token(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end
end
