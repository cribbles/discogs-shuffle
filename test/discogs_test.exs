defmodule DiscogsTest do
  use ExUnit.Case
  doctest Discogs

  test "greets the world" do
    assert Discogs.hello() == :world
  end
end
