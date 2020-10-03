defmodule Aicacia.Id.Web.Schema.User do
  alias OpenApiSpex.Schema

  defmodule Email do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User.Email",
      description: "user email",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        user_id: %Schema{type: :integer, description: "User Id"},
        email: %Schema{type: :string, description: "Email address", format: :email},
        confirmed: %Schema{type: :boolean, description: "Email confirmation status"},
        primary: %Schema{type: :boolean, description: "Email primary status"},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:id, :username, :emails, :inserted_at, :updated_at],
      example: %{
        "id" => 1234,
        "user_id" => 123,
        "email" => "example@domain.com",
        "confirmed" => true,
        "primary" => true,
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end

  defmodule Private do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "User.Private",
      description: "A private user",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Id"},
        username: %Schema{type: :string, description: "User name"},
        email: %Schema{anyOf: [Email]},
        emails: %Schema{type: :array, items: Email},
        inserted_at: %Schema{
          type: :string,
          description: "Creation timestamp",
          format: :"date-time"
        },
        updated_at: %Schema{type: :string, description: "Update timestamp", format: :"date-time"}
      },
      required: [:id, :username, :emails, :inserted_at, :updated_at],
      example: %{
        "id" => 123,
        "username" => "example",
        "email" => %{
          "id" => 1234,
          "user_id" => 123,
          "email" => "example@domain.com",
          "confirmed" => true,
          "primary" => true,
          "inserted_at" => "2017-09-12T12:34:55Z",
          "updated_at" => "2017-09-13T10:11:12Z"
        },
        "emails" => [],
        "inserted_at" => "2017-09-12T12:34:55Z",
        "updated_at" => "2017-09-13T10:11:12Z"
      }
    })
  end
end
