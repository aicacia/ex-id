defmodule Aicacia.User.Web.Router do
  use Aicacia.User.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Aicacia.User.Web.Controller do
    pipe_through :api

    get "/health", HealthCheck, :health
    head "/health", HealthCheck, :health

    scope "/sign_up", SignUp do
      post "/email_password", EmailPassword, :sign_up
    end

    scope "/sign_in", SignIn do
      post "/email_password", EmailPassword, :sign_in
    end
  end
end
