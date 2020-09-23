defmodule Aicacia.User.Web.Controller.SignUp.EmailPassword do
  use Aicacia.User.Web, :controller

  alias Aicacia.User.Service
  alias Aicacia.User.Web.View

  action_fallback Aicacia.User.Web.Controller.Fallback

  def sign_up(conn, params) do
    with {:ok, command} <- Service.SignUp.EmailPassword.new(params),
         {:ok, user} <- Service.SignUp.EmailPassword.handle(command) do
      conn
      |> put_view(View.User)
      |> put_status(200)
      |> render("show.json", user: user)
    end
  end
end
