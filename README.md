# Dashboard

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Configuring backends

### Backends used

Configure which backends are currently being used.

```elixir
config :dashboard, Dashboard.Backend,
  backends: [
    Dashboard.Backend.Pingdom,
    Dashboard.Backend.TravisCI,
    Dashboard.Backend.StatusPage
  ]
```

### Backend secrets
Configuration for the backends should be added to the appropriate secret config for the environment you're targetting. Example: `dev.secret.exs`

```elixir
config :dashboard, Dashboard.Backend.Pingdom,
  email: "<your account email>",
  password: "<your account password>",
  account_email: "purchasing@creditcards.com",
  app_key: "<pingdom app key>"

config :dashboard, Dashboard.Backend.TravisCI,
  github_token: "<github token used to request the travis token>"

config :dashboard, Dashboard.Backend.StatusPage,
  token: "<api token>"
```

## Implementing new backends

The `Dashboard.Backend` module defines the using macro, in order to import the default behaviour just start with the following code.

```elixir
defmodule Dashboard.Backend.<NEW BACKEND> do
  use Dashboard.Backend
end
```

## TODO

- Remove assets?
