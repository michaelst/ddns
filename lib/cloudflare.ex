defmodule Cloudflare do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.cloudflare.com/client/v4")

  plug(Tesla.Middleware.Headers, [
    {"x-auth-key", Application.get_env(:ddns, :cloudflare_api_key)},
    {"x-auth-email", Application.get_env(:ddns, :cloudflare_email)}
  ])

  plug(Tesla.Middleware.JSON)

  @spec record(String.t(), String.t()) :: {:ok, Tesla.Env.t()} | {:error, any}
  def record(zone_identifier, identifier) do
    get("/zones/" <> zone_identifier <> "/dns_records/" <> identifier)
  end

  @spec update_record_ip(String.t(), String.t(), String.t()) :: {:ok, Tesla.Env.t()} | {:error, any}
  def update_record_ip(zone_identifier, identifier, ip) do
    patch("/zones/" <> zone_identifier <> "/dns_records/" <> identifier, %{content: ip})
  end
end
