defmodule Aicacia.Id.Web.Controller.SignIn.EmailPassword do
  use Aicacia.Id.Web, :controller

  alias Aicacia.Id.Service

  action_fallback Aicacia.Id.Web.Controller.Fallback

  def sign_in(conn, params) do
    with {:ok, command} <- Service.SignIn.EmailPassword.new(params),
         {:ok, user} <- Service.SignIn.EmailPassword.handle(command) do
      Aicacia.Id.Web.Controller.User.sign_in_user(conn, {:ok, user})
    end
  end
end
