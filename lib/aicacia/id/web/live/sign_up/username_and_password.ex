defmodule Aicacia.Id.Web.Live.SignUp.UsernameAndPassword do
  use Aicacia.Id.Web, :live_view
  import Ecto.Changeset

  alias Aicacia.Id.Service

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: cast(%Service.SignUp.UsernameAndPassword{}, %{}, []))}
  end

  @impl true
  def handle_event("validate", %{"username_and_password" => params}, socket) do
    changeset =
      params
      |> Service.SignUp.UsernameAndPassword.changeset()
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"username_and_password" => params}, socket) do
    case Service.SignUp.UsernameAndPassword.new(params) do
      {:ok, command} ->
        case Service.SignUp.UsernameAndPassword.handle(command) do
          {:ok, user} ->
            {:noreply, socket |> assign(user: user) |> redirect(to: "/oauth/applications")}

          {:error, %Ecto.InvalidChangesetError{changeset: changeset}} ->
            {:noreply, assign(socket, changeset: changeset |> Map.put(:action, :insert))}
        end

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset |> Map.put(:action, :insert))}
    end
  end
end
