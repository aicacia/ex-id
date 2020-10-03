defmodule Aicacia.Id.Web.Router do
  use Aicacia.Id.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :user_authenticated do
    plug(Aicacia.Id.Web.Plug.UserAuthentication)
  end

  pipeline :api_spec do
    plug OpenApiSpex.Plug.PutApiSpec, module: Aicacia.Id.Web.ApiSpec
  end

  scope "/" do
    pipe_through :browser

    get "/swagger", OpenApiSpex.Plug.SwaggerUI,
      path: "/swagger.json",
      default_model_expand_depth: 10,
      display_operation_id: true
  end

  scope "/" do
    pipe_through :api
    pipe_through :api_spec
    get "/swagger.json", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/", Aicacia.Id.Web.Controller do
    pipe_through :api

    get "/health", HealthCheck, :health
    head "/health", HealthCheck, :health

    scope "/sign_up", SignUp do
      post "/username_and_password", UsernameAndPassword, :sign_up
    end

    scope "/sign_in", SignIn do
      post "/username_or_email_and_password", UsernameOrEmailAndPassword, :sign_in
    end

    scope "/user" do
      pipe_through :user_authenticated

      get "/current", User, :current
      delete "/current", User, :sign_out

      scope "/email", User do
        post("/", Email, :create)
        put("/confirm", Email, :confirm)
        patch("/confirm", Email, :confirm)
        put("/:id/primary", Email, :set_primary)
        patch("/:id/primary", Email, :set_primary)
        delete("/:id", Email, :delete)
      end

      scope "/password", User do
        put("/reset", Password, :reset)
        patch("/reset", Password, :reset)
      end
    end
  end
end
