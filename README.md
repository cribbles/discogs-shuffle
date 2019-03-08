# discogs-shuffle

This is an Elixir-based CLI library that syncs [Discogs](https://discogs.com)
user collections to a local Sqlite3 database.

## Installation

```sh
./bin/build.sh
```

## Usage

```sh
Usage: discogs [options]
    -s, --sync <USER>    Sync a user collection
```

## Tests

Tests are not exhaustive.

```sh
./bin/test.sh
```

## Notes

You might find this library useful if you are an Elixir developer who needs to
work with the Discogs API in some form.

It includes Ecto mappings for the Discogs `User -> Release -> Record` and
`Artist -> Release -> Record` relationships, and could easily be extended.

I kept the Ecto model structs quite slim, since I originally wrote this repo for
a fairly simple use-case (creating a shuffled sample of records to experiment
with aleatory DJ mixes).

Here are a few more reasons this library might be of interest to Elixir
developers:

- as an example of a tested Ecto library that does not include Phoenix
- as an example of a library using the uncommon
  [`sqlite_ecto2`](https://github.com/elixir-sqlite/sqlite_ecto2) adapter
- as an example of a CLI app making very minimal use of Elixir's
  [OptionParser](https://hexdocs.pm/elixir/OptionParser.html)

## Contributing

This project uses [credo](http://credo-ci.org/) and
[formatter](https://hexdocs.pm/mix/master/Mix.Tasks.Format.html) for style
consistency. Please run

```sh
mix format
```

and

```sh
mix credo --strict
```

before committing changes.

## License

MIT
