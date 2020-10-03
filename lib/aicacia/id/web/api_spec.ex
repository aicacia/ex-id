defmodule Aicacia.Id.Web.ApiSpec do
  @behaviour OpenApiSpex.OpenApi

  @impl OpenApiSpex.OpenApi
  def spec,
    do:
      %OpenApiSpex.OpenApi{
        servers: [
          OpenApiSpex.Server.from_endpoint(Aicacia.Id.Web.Endpoint)
        ],
        info: %OpenApiSpex.Info{
          title: Application.spec(:aicacia_id, :description) |> to_string(),
          version: Application.spec(:aicacia_id, :vsn) |> to_string()
        },
        paths: OpenApiSpex.Paths.from_router(Aicacia.Id.Web.Router),
        components: %OpenApiSpex.Components{
          securitySchemes: %{
            "authorization" => %OpenApiSpex.SecurityScheme{type: "http", scheme: "bearer"}
          }
        }
      }
      |> OpenApiSpex.resolve_schema_modules()
end
