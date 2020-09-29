defmodule Aicacia.Id.Web.Controller.SignIn.UsernameOrEmailAndPassword do
  use Aicacia.Id.Web, :controller

  alias Aicacia.Id.Service

  action_fallback Aicacia.Id.Web.Controller.Fallback

  def sign_in(conn, params) do
    with {:ok, command} <- Service.SignIn.UsernameOrEmailAndPassword.new(params),
         {:ok, user} <- Service.SignIn.UsernameOrEmailAndPassword.handle(command) do
      Aicacia.Id.Web.Controller.User.sign_in_user(conn, {:ok, user})
    end
  end
end
