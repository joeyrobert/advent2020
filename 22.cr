players = File.read("22.txt").split("\n\n").map { |player| player.strip.split('\n')[1..].map(&.to_i) }
players_2 = players.clone

# part 1
while players[0].size > 0 && players[1].size > 0
  a = players[0].shift
  b = players[1].shift

  if a > b
    players[0] << a
    players[0] << b
  else
    players[1] << b
    players[1] << a
  end
end

winner = players[0].size > 0 ? players[0] : players[1]
puts sum_winner(winner)

def sum_winner(winner)
  sum = 0
  winner.each_with_index do |card, i|
    sum += card * (winner.size - i)
  end
  sum
end

# part 2
def recursive_combat(players, depth = 0)
  round_cards = Set(String).new
  i = 0
  while players[0].size > 0 && players[1].size > 0
    # early return if we've seen this round
    # using string here is not the most efficient, but fast enough
    deck_key = {players[0], players[1]}.to_s
    if round_cards.includes?(deck_key)
      return 0
    end

    round_cards << deck_key

    a = players[0].shift
    b = players[1].shift

    # have enough => recursive combat
    if players[0].size >= a && players[1].size >= b
      a_cards = players[0][...a]
      b_cards = players[1][...b]
      if recursive_combat([a_cards, b_cards], depth + 1) == 0
        players[0] << a
        players[0] << b
      else
        players[1] << b
        players[1] << a
      end
    else
      # one player must not have enough cards left in their deck
      if a > b
        players[0] << a
        players[0] << b
      else
        players[1] << b
        players[1] << a
      end
    end

    i += 1
  end

  players[0].size > 0 ? 0 : 1
end

winner = recursive_combat(players_2)
puts sum_winner(players_2[winner])
