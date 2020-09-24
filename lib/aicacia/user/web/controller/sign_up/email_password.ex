defmodule Aicacia.User.Web.Controller.SignUp.EmailPassword do
  use Aicacia.User.Web, :controller

  alias Aicacia.User.Service

  action_fallback Aicacia.User.Web.Controller.Fallback

  def sign_up(conn, params) do
    with {:ok, command} <- Service.SignUp.EmailPassword.new(params),
         {:ok, user} <- Service.SignUp.EmailPassword.handle(command) do
      Aicacia.User.Web.Controller.User.sign_in_user(conn, {:ok, user}, 201)
    end
  end
end
