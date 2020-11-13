defmodule Aicacia.Id.Web.Controller.User.Email do
  @moduledoc tags: ["User"]

  use Aicacia.Id.Web, :controller
  use OpenApiSpex.Controller

  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.Controller
  alias Aicacia.Id.Web.View
  alias Aicacia.Id.Web.Schema

  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  action_fallback Controller.Fallback

  @doc """
  Confirm an Eamil

  Confirms an Email and returns the User with the Bearer Token
  """
  @doc responses: [
         ok: {"Confirmed User Email Response", "application/json", Schema.User.Private}
       ]
  def confirm(conn, params) do
    with {:ok, command} <- Service.Email.Confirm.new(params),
         {:ok, email} <- Service.Email.Confirm.handle(command) do
      Controller.User.sign_in_user(conn, Service.User.Show.handle(%{id: email.user_id}))
    end
  end

  @doc """
  Create an Eamil

  Create and returns an Email
  """
  @doc request_body:
         {"Create Email Body", "application/json", Schema.User.EmailCreate, required: true},
       responses: [
         ok: {"Create an Email Response", "application/json", Schema.User.Email}
       ]
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

  @doc """
  Set Email as Primary

  Sets an Email as User's Primary Email
  """
  @doc responses: [
         ok: {"Set Primary Email Response", "application/json", Schema.User.Email}
       ]
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

  @doc """
  Delete an Email

  Delete a non-primary Email
  """
  @doc responses: [
         ok: {"Delete non-primary Email Response", "application/json", Schema.User.Email}
       ]
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
