FROM elixir:1.10

ARG MIX_ENV=prod

RUN mix local.hex --force
RUN mix local.rebar --force

ENV MIX_ENV=${MIX_ENV}

WORKDIR /app

COPY mix.exs /app/mix.exs
COPY mix.lock /app/mix.lock

RUN mix deps.get
RUN mix deps.compile

COPY . /app

ENTRYPOINT /app/entrypoint.sh