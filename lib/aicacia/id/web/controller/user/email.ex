defmodule Aicacia.Id.Web.Controller.User.Email do
  use Aicacia.Id.Web, :controller

  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.Controller
  alias Aicacia.Id.Web.View

  action_fallback Controller.Fallback

  def confirm(conn, params) do
    with {:ok, command} <- Service.Email.Confirm.new(params),
         {:ok, email} <- Service.Email.Confirm.handle(command) do
      Controller.User.sign_in_user(conn, Service.User.Show.handle(%{id: email.user_id}))
    end
  end

  def create(conn, params) do
    user = conn.assigns[:user]

    with {:ok, command} <-
           Service.Email.Create.new(%{user_id: user.id, email: Map.get(params, "email")}),
         {:ok, email} <- Service.Email.Create.handle(command) do
      conn
      |> put_status(201)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end

  def set_primary(conn, params) do
    user = conn.assigns[:user]

    with {:ok, command} <-
           Service.Email.SetPrimary.new(%{user_id: user.id, email_id: Map.get(params, "id")}),
         {:ok, email} <- Service.Email.SetPrimary.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end

  def delete(conn, params) do
    user = conn.assigns[:user]

    with {:ok, command} <-
           Service.Email.Delete.new(%{user_id: user.id, email_id: Map.get(params, "id")}),
         {:ok, email} <- Service.Email.Delete.handle(command) do
      conn
      |> put_status(200)
      |> put_view(View.Email)
      |> render("show.json", email: email)
    end
  end
end
