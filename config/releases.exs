import Config

config :ddns,
  cloudflare_api_key: File.read!("/etc/secrets/CLOUDFLARE_API_KEY"),
  cloudflare_email: File.read!("/etc/secrets/CLOUDFLARE_EMAIL"),
  # format: "#{zone_identifier}:#{identifier}" (comma separated)
  domains: File.read!("/etc/secrets/DOMAINS")
