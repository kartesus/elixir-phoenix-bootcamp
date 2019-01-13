defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  test "create_deck makes 20 cards" do
    deck = Cards.create_deck()
    assert length(deck) == 20
  end

  test "shuffling a deck changes it's order" do
    deck = Cards.create_deck()
    shuffled = Cards.shuffle(deck)

    assert deck != shuffled
    assert Enum.sort(deck) == Enum.sort(shuffled)
  end
end
