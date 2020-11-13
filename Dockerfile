FROM elixir:1.10

ARG MIX_ENV=prod

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /app

ENV MIX_ENV=${MIX_ENV}

COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock

RUN mix deps.get && mix deps.compile

COPY . /app

ENTRYPOINT /app/entrypoint.sh