build:
	mix deps.get
	MIX_ENV=dev make migrate
	mix escript.build

migrate:
	mix ecto.migrate
	cp deps/esqlite/priv/esqlite3_nif.so ./priv/

rebuild:
	rm -f discogs.sqlite3
	make build

test-unit:
	mix deps.get
	MIX_ENV=test make migrate
	mix escript.build
	mix test

