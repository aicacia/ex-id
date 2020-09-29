defmodule Aicacia.Id.Web.Controller.SignUp.UsernameAndPassword do
  use Aicacia.Id.Web, :controller

  alias Aicacia.Id.Service

  action_fallback Aicacia.Id.Web.Controller.Fallback

  def sign_up(conn, params) do
    with {:ok, command} <- Service.SignUp.UsernameAndPassword.new(params),
         {:ok, user} <- Service.SignUp.UsernameAndPassword.handle(command) do
      Aicacia.Id.Web.Controller.User.sign_in_user(conn, {:ok, user}, 201)
    end
  end
end
