defmodule Aicacia.Id.Web.Controller.User.Password do
  use Aicacia.Id.Web, :controller

  alias Aicacia.Id.Service
  alias Aicacia.Id.Web.Controller

  action_fallback Controller.Fallback

  def reset(conn, params) do
    user = conn.assigns[:user]

    with {:ok, command} <-
           Service.Password.Reset.new(%{
             user_id: user.id,
             old_password: Map.get(params, "old_password"),
             password: Map.get(params, "password")
           }),
         {:ok, _password} <- Service.Password.Reset.handle(command) do
      Aicacia.Id.Web.Controller.User.sign_in_user(conn, {:ok, user}, 201)
    end
  end
end
