defmodule Aicacia.User.Web.Controller.SignIn.EmailPassword do
  use Aicacia.User.Web, :controller

  alias Aicacia.User.Service
  alias Aicacia.User.Web.View

  action_fallback Aicacia.User.Web.Controller.Fallback

  def sign_in(conn, params) do
    with {:ok, command} <- Service.SignIn.EmailPassword.new(params),
         {:ok, user} <- Service.SignIn.EmailPassword.handle(command) do
      conn
      |> put_view(View.User)
      |> put_status(200)
      |> render("show.json", user: user)
    end
  end
end
