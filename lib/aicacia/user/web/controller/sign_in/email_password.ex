defmodule Aicacia.User.Web.Controller.SignIn.EmailPassword do
  use Aicacia.User.Web, :controller

  alias Aicacia.User.Service

  action_fallback Aicacia.User.Web.Controller.Fallback

  def sign_in(conn, params) do
    with {:ok, command} <- Service.SignIn.EmailPassword.new(params),
         {:ok, user} <- Service.SignIn.EmailPassword.handle(command) do
      Aicacia.User.Web.Controller.User.sign_in_user(conn, {:ok, user})
    end
  end
end
