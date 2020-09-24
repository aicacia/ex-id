defmodule Aicacia.User.MixProject do
  use Mix.Project

  def organization, do: :aicacia

  def name, do: :user

  def version, do: "0.1.0"

  def project,
    do: [
      app: String.to_atom("#{organization()}_#{name()}"),
      version: version(),
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]

  def application,
    do: [
      mod: {Aicacia.User.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp env(:prod),
    do: [
      DOCKER_REGISTRY: "registry.#{organization()}.com",
      HELM_REPO: "https://chartmuseum.#{organization()}.com"
    ]

  defp env(_),
    do: [
      DOCKER_REGISTRY: "registry.local-k8s.com",
      HELM_REPO: "http://chartmuseum.local-k8s.com"
    ]

  defp deps,
    do: [
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:postgrex, ">= 0.0.0"},
      {:aicacia_handler, "~> 0.1"},
      {:ecto_sql, "~> 3.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.2"},
      {:uuid, "~> 1.1"},
      {:cors_plug, "~> 2.0"},
      {:plug_cowboy, "~> 2.3"},
      {:peerage, "~> 1.0"},
      {:distillery, "~> 2.1"},
      {:bcrypt_elixir, "~> 2.0"},
      {:guardian, "~> 2.0"},
      {:excoveralls, "~> 0.10", only: :test}
    ]

  defp namespace(), do: "api"
  defp helm_dir(), do: "./helm/#{organization()}-#{name()}"
  defp get_env(key), do: Keyword.get(env(Mix.env()), key, "")

  defp docker_repository(), do: "#{get_env(:DOCKER_REGISTRY)}/api/#{name()}"
  defp docker_tag(), do: "#{docker_repository()}:#{version()}"

  defp helm_overrides(),
    do:
      "--set image.tag=#{version()} --set image.repository=#{docker_repository()} --set image.hash=$(mix docker.sha256)"

  defp createHelmInstall(values \\ nil),
    do:
      "helm install #{helm_dir()} --name #{name()} --namespace=#{namespace()} #{helm_overrides()} #{
        if values == nil, do: "", else: "--values #{values}"
      }"

  defp createHelmUpgrade(values \\ nil),
    do:
      "helm upgrade #{name()} #{helm_dir()} --namespace=#{namespace()} --install #{
        helm_overrides()
      } #{if values == nil, do: "", else: "--values #{values}"}"

  defp aliases,
    do: [
      # Dev Postgres
      postgres: [
        "cmd mkdir -p ${PWD}/.volumes/#{name()}-postgres",
        "cmd docker run --rm -d " <>
          "--name #{name()}-postgres " <>
          "-e POSTGRES_PASSWORD=postgres " <>
          "-p 5432:5432 " <>
          "-v ${PWD}/.volumes/#{name()}-postgres:/var/lib/postgresql/data " <>
          "postgres:12-alpine"
      ],
      "postgres.delete": [
        "cmd docker rm -f #{name()}-postgres",
        "cmd rm -rf ${PWD}/.volumes"
      ],

      # Database
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],

      # Docker
      "docker.build": ["cmd docker build --build-arg MIX_ENV=#{Mix.env()} -t #{docker_tag()} ."],
      "docker.push": ["cmd docker push #{docker_tag()}"],
      "docker.sha256": [
        ~s(cmd docker inspect --format='"{{index .Id}}"' #{docker_tag()})
      ],

      # Helm
      "helm.push": [
        "cmd cd #{helm_dir()} && helm push . #{get_env(:HELM_REPO)} --username=\"#{
          get_env(:HELM_REPO_USERNAME)
        }\" --password=\"#{get_env(:HELM_REPO_PASSWORD)}\""
      ],
      "helm.delete": ["cmd helm delete --namespace #{namespace()} #{name()}"],
      "helm.install": ["cmd #{createHelmInstall()}"],
      "helm.install.local": ["cmd #{createHelmInstall("#{helm_dir()}/values-local.yaml")}"],
      "helm.upgrade": ["cmd #{createHelmUpgrade()}"],
      "helm.upgrade.local": ["cmd #{createHelmUpgrade("#{helm_dir()}/values-local.yaml")}"],
      helm: [
        "docker.build",
        "docker.push",
        "helm.upgrade"
      ],
      "helm.local": [
        "docker.build",
        "docker.push",
        "helm.upgrade.local"
      ]
    ]
end
