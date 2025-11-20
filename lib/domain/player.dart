enum Player {
  human,
  ai,
  none;


  Player get opponent => switch (this) {
    Player.human => Player.ai,
    Player.ai => Player.human,
    Player.none => throw StateError('Empty has no opponent'),
  };
}
