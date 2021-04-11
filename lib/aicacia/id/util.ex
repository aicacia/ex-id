defmodule Aicacia.Id.Util do
  def generate_token(length), do: :crypto.strong_rand_bytes(length) |> Base.url_encode64()
end
