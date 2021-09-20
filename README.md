# discogs_shuffle

This is an Elixir library that stores [Discogs](https://discogs.com) user
collections to a local database and allows interaction via
[Ecto](https://github.com/elixir-ecto/ecto) wrappers.

## Installation

```sh
make build
```

## Usage

```sh
./discogs
```

```sh
Usage: discogs [options]
    --sync USER             Sync a user collection
    --shuffle USER <N=30>   Pick n random records from a user collection
```

## Tests

```sh
make test-unit
```

## Notes

You might find this library useful if you are an Elixir developer who needs to
work with the Discogs API in some form.

It includes Ecto mappings for the Discogs `User -> Release -> Record` and
`Artist -> Release -> Record` relationships, and could be easily extended.

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
mix credo -a --strict
```

before committing changes.

### Guidelines

#### Testing

All public functions for the Ecto models should be tested exhaustively,
including `changeset/2`.

#### Documentation

All public modules and their functions should be documented with the
appropriate typespecs.

This library uses
[ExDoc](https://hexdocs.pm/elixir/1.12/writing-documentation.html)
conventions for documentation. You can run

```sh
mix docs
```

to build the docs and open them in your local environment.

Typespecs are validated through
[dialyzer](https://github.com/jeremyjh/dialyxir).

```sh
mix dialyzer
```

## License

MIT
