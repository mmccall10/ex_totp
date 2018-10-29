defmodule ExTotpTest do
  use ExUnit.Case
  doctest ExTotp

  test "greets the world" do
    assert ExTotp.hello() == :world
  end
end
