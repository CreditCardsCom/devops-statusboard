# Dashboard

[![Build Status](https://travis-ci.org/CreditCardsCom/devops-statusboard.svg?branch=master)](https://travis-ci.org/CreditCardsCom/devops-statusboard)

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
config :dashboard,
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

- Improve returned error handling in `<backend>.load()`
- Account for expired token in travis-ci backend

## License (MIT)

Copyright (c) 2017 CreditCards.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
