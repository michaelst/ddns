use Mix.Config

config :ddns,
  cloudflare_api_key: System.get_env("CLOUDFLARE_API_KEY"),
  cloudflare_email: System.get_env("CLOUDFLARE_EMAIL"),
  # format: "#{zone_identifier}:#{identifier}" (comma separated)
  domains: System.get_env("DOMAINS")
