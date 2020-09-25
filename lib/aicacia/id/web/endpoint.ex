defmodule Aicacia.Id.Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :aicacia_id

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  socket "/socket", Aicacia.Id.Web.Socket.User,
    websocket: true,
    longpoll: false

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug CORSPlug

  plug Aicacia.Id.Web.Router
end
