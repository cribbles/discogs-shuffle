MIX_ENV=test mix ecto.migrate
cp deps/esqlite/priv/esqlite3_nif.so ./priv/
mix test
