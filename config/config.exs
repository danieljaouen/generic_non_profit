# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :assisi,
  ecto_repos: [Assisi.Repo]

# Configures the endpoint
config :assisi, AssisiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DL62u/XT7t99TrxDAerMlXboxwmmvKjbRX5QSwW60pgXkgHa1nqn/Fh6ORFwsjZG",
  render_errors: [view: AssisiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Assisi.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "S/eMB3Cm5cQQStfILmUee12CbqMY8/CM"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Assisi.Coherence.User,
  repo: Assisi.Repo,
  module: Assisi,
  web_module: AssisiWeb,
  router: AssisiWeb.Router,
  password_hashing_alg: Comeonin.Bcrypt,
  messages_backend: AssisiWeb.Coherence.Messages,
  registration_permitted_attributes: [
    "email",
    "name",
    "password",
    "current_password",
    "password_confirmation"
  ],
  invitation_permitted_attributes: ["name", "email"],
  password_reset_permitted_attributes: [
    "reset_password_token",
    "password",
    "password_confirmation"
  ],
  session_permitted_attributes: ["remember", "email", "password"],
  email_from_name: "Assisi Institute",
  email_from_email: "noreply@assisi-institute.org",
  opts: [
    :rememberable,
    :authenticatable,
    :recoverable,
    :lockable,
    :trackable,
    :unlockable_with_token,
    :registerable
  ]

config :coherence, AssisiWeb.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: ""

# %% End Coherence Configuration %%
