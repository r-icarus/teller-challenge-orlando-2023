defmodule TashTest do
  use ExUnit.Case
  doctest Tash

  test "greets the world" do
    assert Tash.hello() == :world
  end
end
