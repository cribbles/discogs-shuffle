build:
	mix deps.get
	MIX_ENV=dev mix ecto.migrate
	cp deps/esqlite/priv/esqlite3_nif.so ./priv/
	mix escript.build

rebuild:
	rm discogs.sqlite3
	make build

test-unit:
	mix deps.get
	MIX_ENV=test mix ecto.migrate
	cp deps/esqlite/priv/esqlite3_nif.so ./priv/
	mix escript.build
	mix test

