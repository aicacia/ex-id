defmodule Aicacia.User.Web.Router do
  use Aicacia.User.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :user_authenticated do
    plug(Aicacia.User.Web.Plug.UserAuthentication)
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

    scope "/user" do
      get "/current", User, :current_user
      put "/confirm_email", User, :confirm_email
      patch "/confirm_email", User, :confirm_email
      delete "/sign_out", User, :sign_out
    end
  end
end
