defmodule Aicacia.Id.Web.Router do
  use Aicacia.Id.Web, :router
  use PhoenixOauth2Provider.Router, otp_app: :aicacia_id

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {Aicacia.Id.Web.View.Layout, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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

  scope "/swagger" do
    pipe_through :browser

    get "/", OpenApiSpex.Plug.SwaggerUI,
      path: "/api/swagger.json",
      default_model_expand_depth: 10,
      display_operation_id: true
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/dashboard" do
      pipe_through :browser

      live_dashboard "/",
        metrics: Aicacia.Id.Web.Telemetry,
        ecto_repos: [Aicacia.Id.Repo]
    end
  end

  scope "/" do
    pipe_through :user_authenticated
    oauth_routes()
  end

  scope "/api", as: :api do
    pipe_through :api
    pipe_through :api_spec

    get "/swagger.json", OpenApiSpex.Plug.RenderSpec, []

    oauth_api_routes()

    scope "/", Aicacia.Id.Web.Controller.Api do
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

  scope "/", Aicacia.Id.Web.Live do
    pipe_through :browser

    live "/sign_up/username_and_password", SignUp.UsernameAndPassword, :index
    live "/sign_in/username_or_email_and_password", SignIn.UsernameOrEmailAndPassword, :index
  end
end
