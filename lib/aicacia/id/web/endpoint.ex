defmodule Aicacia.Id.Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :aicacia_id

  @session_options [
    store: :cookie,
    key: "_aicacia_id_key",
    signing_salt: "R3mi5EoH"
  ]

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  socket "/socket", Aicacia.Id.Web.Socket.User,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :aicacia_id,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :aicacia_id
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CORSPlug

  plug Aicacia.Id.Web.Router
end
