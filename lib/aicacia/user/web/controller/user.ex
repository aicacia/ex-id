defmodule Aicacia.User.Web.Controller.User do
  use Aicacia.User.Web, :controller

  alias Aicacia.User.Service
  alias Aicacia.User.Web.View

  action_fallback Aicacia.User.Web.Controller.Fallback

  def index(conn, params) do
    with {:ok, command} <- Service.User.Index.new(params),
         {:ok, users} <- Service.User.Index.handle(command) do
      conn
      |> put_view(View.User)
      |> put_status(200)
      |> render("index.json", users: users)
    end
  end

  def show(conn, params) do
    with {:ok, command} <- Service.User.Show.new(params),
         {:ok, user} <- Service.User.Show.handle(command) do
      conn
      |> put_view(View.User)
      |> put_status(200)
      |> render("show.json", user: user)
    end
  end

  def create(conn, params) do
    with {:ok, command} <- Service.User.Create.new(params),
         {:ok, user} <- Service.User.Create.handle(command) do
      conn
      |> put_view(View.User)
      |> put_status(201)
      |> render("show.json", user: user)
    end
  end

  def update(conn, params) do
    with {:ok, command} <- Service.User.Update.new(params),
         {:ok, user} <- Service.User.Update.handle(command) do
      conn
      |> put_view(View.User)
      |> put_status(200)
      |> render("show.json", user: user)
    end
  end

  def delete(conn, params) do
    with {:ok, command} <- Service.User.Delete.new(params),
         {:ok, user} <- Service.User.Delete.handle(command) do
      conn
      |> put_view(View.User)
      |> put_status(200)
      |> render("show.json", user: user)
    end
  end
end
