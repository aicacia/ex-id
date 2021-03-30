defmodule Aicacia.Id.Web.Live.SignIn.UsernameOrEmailAndPassword do
  use Aicacia.Id.Web, :live_view
  import Ecto.Changeset

  alias Aicacia.Id.Service

  defmodule UsernameOrEmailAndPassword do
    use Ecto.Schema

    schema "" do
      field(:username_or_email, :string)
      field(:password, :string)

      field(:email, :string)
      field(:username, :string)
    end

    def changeset(%{} = attrs) do
      %Service.SignIn.UsernameOrEmailAndPassword{}
      |> cast(attrs, [:username_or_email, :password])
      |> validate_required([:username_or_email, :password])
      |> Service.SignIn.UsernameOrEmailAndPassword.validate_username_or_email()
    end
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: cast(%UsernameOrEmailAndPassword{}, %{}, []))}
  end

  @impl true
  def handle_event("validate", %{"username_or_email_and_password" => params}, socket) do
    changeset =
      params
      |> UsernameOrEmailAndPassword.changeset()
      |> Map.put(:action, :insert)

    IO.inspect(changeset)
    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"username_or_email_and_password" => params}, socket) do
    case Service.SignIn.UsernameOrEmailAndPassword.new(params) do
      {:ok, command} ->
        case Service.SignIn.UsernameOrEmailAndPassword.handle(command) do
          {:ok, user} ->
            {:noreply, socket |> assign(user: user) |> redirect(to: "/")}

          {:error, %Ecto.InvalidChangesetError{changeset: changeset}} ->
            IO.inspect(changeset)
            {:noreply, assign(socket, changeset: changeset |> Map.put(:action, :insert))}
        end

      {:error, changeset} ->
        IO.inspect(changeset)
        {:noreply, assign(socket, changeset: changeset |> Map.put(:action, :insert))}
    end
  end
end
