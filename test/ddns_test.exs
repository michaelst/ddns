defmodule DdnsTest do
  use ExUnit.Case
  doctest Ddns

  test "greets the world" do
    assert Ddns.hello() == :world
  end
end
