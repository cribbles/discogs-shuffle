mix deps.get
MIX_ENV=test mix ecto.migrate
cp deps/esqlite/priv/esqlite3_nif.so ./priv/
mix escript.build
mix test
