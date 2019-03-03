mix deps.get
mix ecto.migrate
cp deps/esqlite/priv/esqlite3_nif.so ./priv/
mix escript.build

