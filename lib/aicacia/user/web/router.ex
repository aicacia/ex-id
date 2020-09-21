defmodule Aicacia.User.Web.Router do
  use Aicacia.User.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Aicacia.User.Web.Controller do
    pipe_through :api

    get "/health", HealthCheck, :health
    head "/health", HealthCheck, :health

    resources "/user", User, only: [:index, :show, :create, :update, :delete]
  end
end
